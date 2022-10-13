local ffi = require("ffi")
if jit.os == "Linux" then
    local uuid = ffi.load("libuuid.so", true)
end

ffi.cdef [[
typedef unsigned char uuid_t[16];
void uuid_generate_random(uuid_t out);
void uuid_generate_time(uuid_t out);
void uuid_unparse(uuid_t uu, char *out);
]]

local _M = {
    _VERSION = '0.01'
}

local mt = {
    __index = _M
}

local function _char2uchar(c)
    if c < 0 then
        c = c + 256
    end
    return c
end

function _M.uuid1(self)
    local uu = ffi.new("char[16]")
    ffi.C.uuid_generate_time(uu)

    return setmetatable({
        _uu = uu
    }, mt)
end

function _M.uuid4(self)
    local uu = ffi.new("char[16]")
    ffi.C.uuid_generate_random(uu)

    return setmetatable({
        _uu = uu
    }, mt)
end

function _M.uuid_hex(self)
    if self._uu == nil then
        return nil
    end
    hex = string.format("%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", _char2uchar(self._uu[0]),
        _char2uchar(self._uu[1]), _char2uchar(self._uu[2]), _char2uchar(self._uu[3]), _char2uchar(self._uu[4]),
        _char2uchar(self._uu[5]), _char2uchar(self._uu[6]), _char2uchar(self._uu[7]), _char2uchar(self._uu[8]),
        _char2uchar(self._uu[9]), _char2uchar(self._uu[10]), _char2uchar(self._uu[11]), _char2uchar(self._uu[12]),
        _char2uchar(self._uu[13]), _char2uchar(self._uu[14]), _char2uchar(self._uu[15]));
    return hex
end

function _M.uuid_str(self)
    if self._uu == nil then
        return nil
    end
    local str = ffi.new("char[37]")
    ffi.C.uuid_unparse(self._uu, str);
    return ffi.string(str)
end

function _M.uuid_num(self)
    if self._uu == nil then
        return nil
    end
    local i = 0
    local n = 0
    while i < 16 do
        n = _char2uchar(self._uu[i]) + n * 256;
        i = i + 1
    end

    return n;
end

return _M
