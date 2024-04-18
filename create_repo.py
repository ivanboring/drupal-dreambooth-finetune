from huggingface_hub import create_repo
import sys
private_bool = False
if sys.argv[2] == "true":
  private_bool = True
create_repo(sys.argv[1], private=private_bool)
