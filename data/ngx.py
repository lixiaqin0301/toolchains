"""LLDB pretty-printers for nginx's length-prefixed string types.

ngx_str_t is `{ size_t len; u_char *data; }` and is *not* NUL-terminated: `data`
usually points into a bigger buffer (the request line / header buffer), so
printing it with `%s` -- or via the `u_char *` summary in ~/.lldbinit -- keeps
going past `len` into whatever follows ("/mytest HTTP/1.1\r\nHost..."). This
provider reads exactly `len` bytes instead.

Install with:
    command script import /root/.lldb/ngx.py
"""

import lldb

# Summaries are rendered inline in the UI, so don't dump megabytes into them.
MAX_BYTES = 256


def _escape(raw):
    out = []
    for byte in raw:
        ch = chr(byte)
        if ch == "\\":
            out.append("\\\\")
        elif ch == '"':
            out.append('\\"')
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\r":
            out.append("\\r")
        elif ch == "\t":
            out.append("\\t")
        elif 0x20 <= byte < 0x7F:
            out.append(ch)
        else:
            out.append("\\x%02x" % byte)
    return "".join(out)


def ngx_str_summary(valobj, _internal_dict):
    # lldb applies summaries to pointers-to-type too, so `p &r->uri` lands here.
    if valobj.GetType().IsPointerType():
        valobj = valobj.Dereference()
        if not valobj.IsValid():
            return "<null>"

    length = valobj.GetChildMemberWithName("len").GetValueAsUnsigned(0)
    address = valobj.GetChildMemberWithName("data").GetValueAsUnsigned(0)
    if not address:
        return "NULL"
    if length <= 0:
        # ReadMemory rejects a zero length outright.
        return '""'

    process = valobj.GetProcess()
    if process is None or not process.IsValid():
        return "<no process>"

    error = lldb.SBError()
    raw = process.ReadMemory(address, length, error)
    if not error.Success():
        return "<unreadable: %d bytes @ 0x%x>" % (length, address)

    text = '"%s"' % _escape(raw[:MAX_BYTES])
    if length > MAX_BYTES:
        text += " ... (%d bytes total)" % length
    return text


def __lldb_init_module(debugger, _internal_dict):
    debugger.HandleCommand("type summary add -F ngx.ngx_str_summary ngx_str_t")
