#!/bin/bash
clear
if ! command -v curl > /dev/null; then

  sudo apt-get install -y curl
fi
if ! command -v toilet  > /dev/null; then

  sudo apt-get install -y toilet 
fi

if ! command -v tor > /dev/null; then

  sudo apt-get install -y tor
fi


if ! pgrep -x "tor" > /dev/null; then
 
  systemctl start tor
  echo "[+] Starting Tor service"
else 
    echo "[+] Tor service already started"
fi

toilet -f bigascii12  Dorker
echo "Made By youhacker55 |github:https://github.com/youhacker55"                                                                                  
read -p "Enter Dork list: " dork_res


read -p "Results file name: " output_file


read -p "how much threads you want to use: " num_threads


results=()


while read -r dork; do

  for ((i=0; i<num_threads; i++)); do
    (
      # Set up the Tor proxy
      export http_proxy="socks5://127.0.0.1:9050"
      export https_proxy="socks5://127.0.0.1:9050"


      result=$(curl -s "https://www.bing.com/search?q=$dork" | grep -oP '<h2><a href="\K\S+')


      if ! [[ " ${results[@]} " =~ " ${result} " ]]; then

        results+=($result)


        echo "Found new URL for dork '$dork': $result"


        echo "$result" >> "$output_file"
      fi
    ) &
  done
done < "$dork_res"


wait