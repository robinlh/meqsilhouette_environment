import sys
import json

input_file = sys.argv[1]
with open(input_file) as f:
  data = json.load(f)

print(data)

with open('/home/meqsil_user/data/output.json', 'w+') as outfile:
    json.dump(data, outfile)

print('wrote outfile')