import re

# with open('default.txt', 'r') as f:
with open('my_lut.txt', 'r') as f:
    for line in f.readlines():
        scan_line = re.search('ad9361_cmd_data[\s]=[\s]{(.*)};', line)
        if scan_line:
            print(scan_line.group(1).strip().replace('\t', ' '))
