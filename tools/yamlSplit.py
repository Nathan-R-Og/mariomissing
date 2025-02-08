import yaml
import os
import hashlib
import shutil
from glob import glob

def doSplit(dir):
    yamlname = dir+".yaml"
    if not os.path.exists(yamlname):
        print("yaml does not exist! skipping...")
        return
    data_loaded = yaml.safe_load(open(yamlname, 'r'))
    suffix = data_loaded["suffix"]
    rom = ""
    for mrom in glob(f"*{suffix}"):
        hash = hashlib.md5(open(mrom,'rb').read()).hexdigest()
        if hash == data_loaded["md5"]:
            rom = mrom
            break
    if rom == "":
        return

    rom_bytes = open(rom, "rb").read()
    rom_name = data_loaded["name"]
    print(f"splitting {rom} for {rom_name} assets")

    if dir == "split":
        output = f"{dir}/"
    else:
        output = f"split/{dir}/"
    output += "banks/"

    bankspace = data_loaded["options"]["bank_size"]

    if os.path.exists(output):
        shutil.rmtree(output)
    os.makedirs(output)

    for entry in data_loaded["splits"]:
        mybank = entry["bank"]
        atI = mybank
        opposite = atI+1
        atI *= bankspace
        opposite *= bankspace
        bankData = rom_bytes[atI:opposite]
        bankend = bankspace
        if "end" in list(entry.keys()):
            bankend = entry["end"]

        if not "splits" in list(entry.keys()):
            fake_bank = hex(mybank).replace("0x","")
            usename = f"bank{fake_bank}"
            end_result = f'{output}{usename}.bin'
            open(end_result, "wb").write(bankData[0:bankend])
            continue

        i = 0
        while i < len(entry["splits"]):
            real_entry = entry["splits"][i]
            start = real_entry[0]
            end = 0
            if i < len(entry["splits"])-1:
                end = entry["splits"][i+1][0]
            else:
                end = bankend
            usename = ""
            if len(real_entry) > 1:
                usename = real_entry[1]
            else:
                fake_addr = hex(start).replace("0x","")
                fake_bank = hex(mybank).replace("0x","")
                usename = f"bank{fake_bank}/unk{fake_addr}"
            end_result = f'{output}{usename}.bin'
            pathOnly = end_result.split("/")
            pathOnly.pop(-1)
            pathOnly = "/".join(pathOnly)
            if not os.path.exists(pathOnly):
                os.makedirs(pathOnly)
            open(end_result, "ab").write(bankData[start:end])
            i += 1
