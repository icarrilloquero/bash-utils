#!/bin/bash
for file in *"%20"*; do
  mv -- "$file" "${file//%20/ }"
done

for file in *"%21"*; do
  mv -- "$file" "${file//%21/\!}"
done

for file in *"%27"*; do
  mv -- "$file" "${file//%27/\'}"
done

for file in *"%28"*; do
  mv -- "$file" "${file//%28/\(}"
done

for file in *"%29"*; do
  mv -- "$file" "${file//%29/\)}"
done

for file in *"%C3%B1"*; do
  mv -- "$file" "${file//%C3%B1/ñ}"
done

for file in *"%C3%A9"*; do
  mv -- "$file" "${file//%C3%A9/é}"
done
