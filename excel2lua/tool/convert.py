#!/usr/bin/python\
# -*- coding: utf-8 -*-

import xlrd
import os
import string
import shutil
import sys
import re

reload(sys) 
sys.setdefaultencoding("utf-8")

# 将数据导出到tgt_lua_path
def excel2lua(src_excel_path, tgt_lua_path):
    print('[file] %s -> %s' % (src_excel_path, tgt_lua_path))
    # load excel data
    excel_data_src = xlrd.open_workbook(src_excel_path, encoding_override = 'utf-8')
    print('[excel] Worksheet name(s):', excel_data_src.sheet_names())
    excel_sheet = excel_data_src.sheet_by_index(0)
    print('[excel] parse sheet: %s (%d row, %d col)' % (excel_sheet.name, excel_sheet.nrows, excel_sheet.ncols))

    # excel data dict
    excel_data_dict = {}

    # col name list
    col_name_list = []

    #col val type list
    col_val_type_list = []

    # ctype: 0 empty, 1 string, 2 number, 3 date, 4 boolean, 5 error

    # 遍历第二行的所有列 保存字段名
    for col in range(0, excel_sheet.ncols):
        cell = excel_sheet.cell(1, col)
        col_name_list.append(str(cell.value))
        assert cell.ctype == 1, "found a invalid col name in col [%d] !~" % (col)

    # 遍历第三行的所有列 保存数据类型
    for col in range(0, excel_sheet.ncols):
        cell = excel_sheet.cell(2, col)
        col_val_type_list.append(str(cell.value))
        assert cell.ctype == 1, "found a invalid col val type in col [%d] !~" % (col)

    # 剔除表头、字段名和字段类型所在行 从第四行开始遍历 构造行数据
    for row in range(3, excel_sheet.nrows):
        # 保存数据索引 默认第一列为id
        cell_id = excel_sheet.cell(row, 0)

        assert cell_id.ctype == 2, "found a invalid id in row [%d] !~" % (row)

        # 检查id的唯一性
        if cell_id.value in excel_data_dict:
            print('[warning] duplicated data id: "%d", all previous value will be ignored!~' % (cell_id.value))

        # row data list
        row_data_list = []

        # 保存每一行的所有数据
        for col in range(0, excel_sheet.ncols):
            cell = excel_sheet.cell(row, col)
            k = col_name_list[col]
            cell_val_type = col_val_type_list[col]

            # ignored the string that start with '_'
            if str(k).startswith('_'):
                continue

            # 根据字段类型去调整数值 如果为空值 依据字段类型 填上默认值
            if cell_val_type == 'string':
                if cell.ctype == 0:
                    v = '\'\''
                else:
                    v = '\'%s\'' % (cell.value)
            elif cell_val_type == 'int':
                if cell.ctype == 0:
                    v = 0
                else:
                    v = int(cell.value)
            elif cell_val_type == 'float':
                if cell.ctype == 0:
                    v = 0
                else:
                    v = float(cell.value)
            elif cell_val_type == 'table':
                if cell.ctype == 0:
                    v = '{}'
                else:
                    v = cell.value
            else:
                v = cell.value

            # 加入列表
            row_data_list.append([k, v])

        # 保存id 和 row data
        excel_data_dict[cell_id.value] = row_data_list

    # 正则搜索lua文件名 不带后缀 用作table的名称 练习正则的使用
    searchObj = re.search(r'([^\\/:*?"<>|\r\n]+)\.\w+$', tgt_lua_path, re.M|re.I)
    lua_table_name = searchObj.group(1)
    # print('正则匹配:', lua_table_name, searchObj.group(), searchObj.groups())

    # 这个就直接获取文件名了
    src_excel_file_name = os.path.basename(src_excel_path)
    tgt_lua_file_name = os.path.basename(tgt_lua_path)

    # export to lua file
    lua_export_file = open(tgt_lua_path, 'w')
    lua_export_file.write('_cfg.%s = {\n' % lua_table_name)

    # 遍历excel数据字典 按格式写入
    for k, v in excel_data_dict.items():
        lua_export_file.write('  [%d] = {\n' % k)
        for row_data in v:
            lua_export_file.write('   {0} = {1},\n'.format(row_data[0], row_data[1]))
        lua_export_file.write('  },\n')

    lua_export_file.write('}\n')

    lua_export_file.close()

    print('[excel] %d row data exported!~' % (excel_sheet.nrows))

def make_dirs(dir):
	if(not os.path.exists(dir)):
		os.makedirs(dir);

def walk_path(walkArgs):
	make_dirs(walkArgs["client_data_dir"]);
	cfg_root = os.path.normpath(os.path.abspath(walkArgs["cfg_dir"]));
	g = os.walk(cfg_root);
	for path,dir_list,file_list in g:
		for file_name in file_list:
			if "~$" in file_name:
				continue
			src_path = os.path.normpath(os.path.abspath(os.path.join(path, file_name)));
			if(not os.path.isfile(src_path)):
				continue;
			table_name, sep, tail = file_name.partition(".");
			target_file_name = table_name + ".lua";
			target_path = os.path.normpath(os.path.abspath(os.path.join(path + "\\" + walkArgs["client_data_dir"], target_file_name)));
			print(src_path);
			print(target_path);
			excel2lua(src_path,target_path);			
	
#----------------------------------------------------------------------
def main():
	""""""
	walkArgs = {
		"client_data_dir":r"../client/",
		"cfg_dir":r"../src",
	}
	
	retCode = walk_path(walkArgs);
	raw_input('Press Enter to exit...')
	if retCode > 0:
		os._exit(1)
	else:
		os._exit(0)

if __name__ == "__main__":

	main()
	
	
