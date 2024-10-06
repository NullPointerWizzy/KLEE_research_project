import re

pattern = re.compile(r'^(?!.*(?:text)).*object.*')
pattern2 = re.compile(r'.*args.*')
pattern3 = re.compile(r'.*Analyse.*')
last = re.compile(r'(?<=\')([^\'$])')
pattern4 = re.compile(r'^.*object.*text.*$')
pattern5 = re.compile(r'.*REPLAY.*')



new_line = []
def transform_file(input_file,output):
    with open(input_file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if not (pattern.match(line) or pattern2.match(line) or pattern3.match(line) or pattern5.match(line)):
                if pattern4.match(line):
                    mots = line.split()
                    new_line.append(mots[-1]+"\n")
                else:
                    new_line.append(line)
    
    with open(output, 'w') as file:
        file.writelines(new_line)


transform_file( "output_ktest-tool_replay.txt","output_lisible.txt")
