import re
from art import *

lut_str = "\t\t13'd{:<4d}:\tad9361_cmd_data\t= {{1'b{}, 10'h{}, 8'h{}}};"

tmp = '=' * 50 + '\n'
# tmp += text2art("SITLINV")
# tmp += '=' * 50 + '\n'
tmp += text2art("BRIANSUNE")
tmp += '=' * 50 + '\n'
tmp += 'File Name: ad9361_lut.v' + '\n'
tmp += '=' * 50 + '\n'
tmp += 'Programed By: BrianSune\n'
tmp += 'Contact: briansune@gmail.com\n'

output_str = ''.join('// {}\n'.format(tps) for tps in tmp.split('\n'))
output_str += '\nfunction [18 : 0] ad9361_cmd_data;\n'
output_str += 'input [12 : 0] index;\n'
output_str += '''
begin
    case(index)
        13'd0   :\tad9361_cmd_data\t= {1'b1, 10'h000, 8'h00};
'''

# print(output_str)

lut_idx = 1
output_str2 = ''

check_list = []
wait_list = []

path = r'C:\Users\briansuneZ\Desktop\golden_ad9361_fm_lvds'
# path = r'C:\Users\briansuneZ\Desktop\golden_ad9361_bist_lvds_rx'
# path = r'C:\Users\briansuneZ\Desktop\golden_ad9361_bist_loop_lvds'
path += r'\ad9361_ini'

with open(path, 'r') as f:
    for line in f.readlines():
        wr_re = re.search(r'SPIWrite[\s]+([0-9A-F]+),([0-9A-F]+)[\s]*[/ ]*(.*)', line)
        rd_re = re.search(r'SPIRead[\s]+([0-9A-F]+)[\s]*[/ ]*(.*)', line)
        cal_re = re.search(r'WAIT_CALDONE[\s]+.*[/]+ (.*0x([0-9A-F]+).*)', line)
        if wr_re:
            # print(wr_re.groups())
            tmp_str = lut_str.format(lut_idx, 1, wr_re.group(1), wr_re.group(2))
            if wr_re.group(3):
                tmp_str += '\t// {}'.format(wr_re.group(3))
            tmp_str += '\n'
            output_str2 += tmp_str
            lut_idx += 1
        if rd_re:
            # print(rd_re.groups())
            tmp_str = lut_str.format(lut_idx, 0, rd_re.group(1), '00')
            if rd_re.group(2):
                tmp_str += '\t// {}'.format(rd_re.group(2))
            tmp_str += '\n'
            output_str2 += tmp_str
            check_list.append('{} {}'.format(lut_idx, rd_re.group(2)))
            lut_idx += 1
        if cal_re:
            # print(cal_re.groups())
            tmp_str = lut_str.format(lut_idx, 0, cal_re.group(2), '00')
            tmp_str += '\t// {}\n'.format(cal_re.group(1))
            output_str2 += tmp_str
            check_list.append('{} {}'.format(lut_idx, cal_re.group(1)))
            lut_idx += 1
        if line.strip() == 'ReadPartNumber':
            output_str2 += lut_str.format(lut_idx, 0, '037', '00') + '\t// ReadPartNumber\n'
            check_list.append('{} {}'.format(lut_idx, 'part num'))
            lut_idx += 1

        if line[0:4] == 'WAIT':
            wait_list.append('{} {}'.format(lut_idx - 1, line.strip()))

output_str += output_str2
output_str += lut_str.format(lut_idx, 1, '014', '68')
output_str += '''
    endcase
end
endfunction
'''

# print(output_str)
with open('ad9361_lut.v', 'w') as wf:
    wf.write(output_str)

[print(ck) for ck in check_list]
print('\n\n')
[print(wi) for wi in wait_list]
