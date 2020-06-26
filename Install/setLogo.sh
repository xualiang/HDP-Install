#!/bin/bash

source `dirname $0`/head.sh

function change_title(){
  sed -i "s/'app.name':'Ambari'/'app.name':'泰华智慧'/g" ${logo_file_path}
  sed -i "s/'app.name.subtitle':'Ambari - {0}'/'app.name.subtitle':'Telchina - {0}'/g" ${logo_file_path}
  sed -i "s/('title').text('Ambari - ' + name)/('title').text('Telchina - ' + name)/g" ${logo_file_path}
  sed -i 's/alt=\\\"Apache Ambari\\\"/alt=\\\"Telchina\\\"/g' ${logo_file_path}
  sed -i 's/title=\\\"Apache Ambari\\\"/title=\\\"Telchina\\\"/g' ${logo_file_path}
  echo "done! Title change successfull!"
  return 0
}

function change_logo_img(){
  cp $logo_img $img_path
  cp $logo_white_img $img_path
  echo "done! Logo image change successfull!"
  return 0
}

main(){
  local result=0

  if [ -f ${logo_file_path} ]; then
    change_title
  elif [ -f ${gz_file_path} ]; then
    gunzip ${gz_file_path}
    change_title
  else
    echo "not found file: app.js or app.js.gz, please check!"
    result=1
  fi
  if [ -d ${img_path} ]; then
    if [ -f ${logo_img} ] && [ -f ${logo_white_img} ]; then
      change_logo_img
    else
      echo "image file is not found,please check the logo img file!"
      result=1
    fi
  else
    echo "not find directory ${img_path},please check!"
    result=1
  fi

  return $result
}

main
