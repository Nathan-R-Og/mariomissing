from math import floor

bytes = open("split/banks/titlefont_gfx.bin", "rb").read()

header = bytes[0]
i = 1
if header != 3:
    exit(hash("wtf"))

byteoutput = bytearray()
buffer = bytearray()
while len(buffer) < 0x1000:
    buffer.append(0)
bufferI = 0

while i < len(bytes):
    bitmask = bytes[i]
    i += 1

    quit = False
    for bit in range(8):
        significant = abs(bit - 7)
        byteTest = bool(bitmask & (1 << significant))
        if byteTest:
            byteoutput.append(bytes[i])
            buffer[bufferI] = bytes[i]
            bufferI += 1
            bufferI &= 0xFFF
        #code
        else:
            code = int.from_bytes(bytes[i:i+2], "big")
            if code == 0:
                quit = True
                break

            offset = ((code & 0b1111111111110000) >> 4)
            amount =   code & 0b0000000000001111
            offset -= 1
            amount += 2

            toAppend = buffer[offset:offset+amount]
            for x in range(len(toAppend)):
                byteoutput.append(toAppend[x])
                buffer[bufferI] = toAppend[x]
                bufferI += 1
                bufferI &= 0xFFF


            i += 1


        i += 1
    if quit: break

print(byteoutput)
open('test.bin', "wb").write(byteoutput)