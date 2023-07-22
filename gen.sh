set -e;

scriptDir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
echo $scriptDir
goOutDir=$scriptDir/proto/health_check;

mkdir -p $goOutDir;

protoc -I=$scriptDir/proto \
  --go_out=$goOutDir --go_opt=paths=source_relative \
  --go-grpc_out=$goOutDir --go-grpc_opt=paths=source_relative \
  health_check.proto;
