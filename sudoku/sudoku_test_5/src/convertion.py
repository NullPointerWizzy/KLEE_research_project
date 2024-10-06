import re

pattern = re.compile(r'^(?!.*(?:uint)).*object.*')
pattern2 = re.compile(r'.*args.*')
pattern3 = re.compile(r'.*Analyse.*')
last = re.compile(r'(?<=\')([^\'$])')
pattern4 = re.compile(r'^.*object.*uint.*$')

input = [
    "-a",
    "-g",
    "-g1",
    "-g2",
    "-g3",
    "-g4",
    "-u",
    "-v",
    "-V",
    "-h",
    "../test/grid-parser/grid-00-empty_file-fail.sku",
    "../test/grid-parser/grid-09-unknown_char_l1_c1-fail.sku",
    "../test/grid-parser/grid-10-unknown_char_l7_c12-fail.sku",
    "../test/grid-parser/grid-11-missing_char_l9-fail.sku",
    "../test/grid-parser/grid-12-extra_char_l10-fail.sku",
    "../test/grid-parser/grid-13-missing_line-fail.sku",
    "../test/grid-parser/grid-14-extra_line-fail.sku",
    "../test/grid-parser/grid-15-empty_line-pass.sku",
    "../test/grid-parser/grid-16-whole_line_commented_out-pass.sku",
    "../test/grid-parser/grid-17-end_with_EOF_no_endofline-pass.sku",
    "../test/grid-parser/grid-18-size_1_end_with_EOF_no_endofline-pass.sku",
    "../test/grid-parser/grid-19-start_with_comment_and_empty_line-pass.sku",
    "../test/grid-parser/grid-20-size_17-fail.sku",
    "../test/grid-parser/grid-21-commented_char_l4-fail.sku",
    "../test/grid-parser/grid-22-comment_at_last_line-pass.sku",
    "../test/grid-parser/grid-23-missing_char_with_EOF_no_endofline-fail.sku",
    "../test/grid-parser/grid-24-only_a_comment_no_grid-fail.sku",
    "../test/grid-parser/grid-25-only_a_comment_grid_end_with_no_endofline_before_EOF-fail.sku",
    "../test/grid-parser/grid-26-random_number_of_spaces_tabs-pass.sku",
    "../test/grid-parser/grid-27-wrong_char_on_first_line-fail.sku",
    "../test/grid-parser/grid-28-size_1_with_EOF_no_endofline_and_wrong_char-fail.sku",
    "../test/grid-solver/grid-01x01-01.sku",
    "../test/grid-solver/grid-16x16-06-twice_char_8_in_line-inconsistent.sku",
    "../test/grid-solver/grid-04x04-01.sku",
    "../test/grid-solver/grid-16x16-07-twice_char_A_in_columns-inconsistent.sku",
    "../test/grid-solver/grid-04x04-02.sku",
    "../test/grid-solver/grid-16x16-08-twice_char_B_in_a_block-inconsistent.sku",
    "../test/grid-solver/grid-09x09-02.sku",
    "../test/grid-solver/grid-36x36-03-inconsistent.sku"
]



new_line = []
def transform_file(input_file,output):
    with open(input_file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if not (pattern.match(line) or pattern2.match(line) or pattern3.match(line)):
                if pattern4.match(line):
                    mots = line.split()
                    new_line.append(input[int(mots[-1])]+"\n")
                else:
                    new_line.append(line)
    
    with open(output, 'w') as file:
        file.writelines(new_line)


transform_file( "output_ktest_tool_replay.txt","output_lisible.txt")
