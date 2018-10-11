"""
Convert the item.dat saved by 1990's DOS Turbo Pascal, into one readable by
Free Pascal 3.0.4 on Win7 is 2018.
"""

with open('item.dat', 'rb') as fin:
    with open('item.fixed.dat', 'wb') as fout:
        while True:
            chunk = fin.read(590)
            if len(chunk) < 590:
                print("Chunk length: %d, done." % len(chunk))
                break
            data = list(chunk)
            # One byte extension of final 'contents' string, seems to make Free Pascal happy
            data.insert(590, 0)
            # Three byte extension of byte 250 with 0s, making it a 4 byte field
            data.insert(251, 0)
            data.insert(251, 0)
            data.insert(251, 0)
            # Two byte extension of byte 249 with 0s, making it a 3 byte field
            data.insert(250, 0)
            data.insert(250, 0)
            fout.write(bytes(data))
