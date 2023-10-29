# func.sh
vurl() {
response=$(curl -s --request POST --url https://www.virustotal.com/api/v3/urls --header 'x-apikey: <your API key>' --form url=$1 | jq -r '.data.id')
parsed_part="${response#*-}"
parsed_part="${parsed_part%%-*}"
url="https://www.virustotal.com/api/v3/urls/$parsed_part"
response=$(curl -s --request GET --url $url --header 'x-apikey: <your API key>' | grep category | cut -d ':' -f 2 | sort | uniq -c)
echo -e $response}

vfile(){
filename="$1"
# Check if the file exists
if [ ! -f "$filename" ]
	then
	echo "File does not exist: $filename"
	return 1
fi
echo "computing file size"
size=$(ls -sh "$filename" | awk '{print $1}')
numeric_value="${size%"${size: -1}"}"
# Check the last character and convert it to a numeric value
last_char="${size: -1}"
case "$last_char" in
  [0-9]) size="${numeric_value}";;  # If it's a digit, no change
  K) size=$((numeric_value * 1024));;  # If it's "K," convert to kilobytes
  M) size=$((numeric_value * 1024 * 1024));;  # If it's "M," convert to megabytes
  G) size=$((numeric_value * 1024 * 1024 * 1024));;  # If it's "G," convert to gigabytes
esac
if [[ $size -le 20000000 && $size -ne 0 ]]; then
echo "uploading file to virustotal"
id=$(curl -s --request POST \
	--url https://www.virustotal.com/api/v3/files \
	--header 'accept: application/json' \
	--header 'content-type: multipart/form-data' \
	--header 'x-apikey: <your API key>' \
	--form file=@$filename | jq -r '.data.id')
url="https://www.virustotal.com/api/v3/analyses/$id"
echo "getting stats from virustotal"
response=$(curl -s --request GET \
--url $url \
--header 'x-apikey: <your API key>' | grep category | cut -d ':' -f 2 | sort | uniq -c);
echo $response; 

elif [[ $size -gt 20000000 && $size -le 200000000 ]]; then
url=$(curl -s --request GET \
--url https://www.virustotal.com/api/v3/files/upload_url \
--header 'x-apikey: <your API key>' | jq -r '.data')
echo "uploading file to virustotal"
id=$(curl -s --request POST \
	--url $url \
	--header 'accept: application/json' \
	--header 'content-type: multipart/form-data' \
	--header 'x-apikey: <your API key>' \
	--form file=@$filename | jq -r '.data.id')
url="https://www.virustotal.com/api/v3/analyses/$id"
echo "getting stats from virustotal"
response=$(curl -s --request GET \
--url $url \
--header 'x-apikey: <your API key>' | jq -r '.data.attributes.stats');
echo $response;

elif [[ $size -eq 0 ]]; then
  echo "File is empty"

elif [[ $size -gt 200000000 ]]; then
  echo "File is too big > 200MB"
fi
}


vip() {
response=$(curl -s --request GET \
	--url https://www.virustotal.com/api/v3/ip_addresses/$1 \
	--header 'x-apikey: <your API key>' | jq -r '.data.attributes.last_analysis_stats') ;
echo $response;}
