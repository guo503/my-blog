#!/bin/bash -ilex
#####  jenkins发布  ####

#####  传参获取需要更新的项目和版本信息
#项目
project_name=$1

#####  需要操作的远端目录路径
path=/usr/project/${project_name}

#####  要修改内容的远端文件夹
target_dir=${path}

#####jar目录
echo "path = ${path}"
echo "target_dir = ${target_dir}"

  
    if [ -d ${path} ]; then
        echo '停止服务：'${project_name};                                                     
        psid_str=$(echo $(ps -ef | grep nginx | grep -v grep));
       if [ -n "$psid_str" ];then
          psids=$(echo $psid_str | awk '{print $2}')
          for i in ${psids};
          do
             echo '服务pid：'$i;
             kill -9 $i
          done
        fi
        

        echo '-------------------------------------------------------------------------------------';
        echo '从jenkins目录复制到project目录：'${target_dir};
        rm -rf ${path}/*;
        cp -r /var/lib/jenkins/workspace/${project_name}/* ${target_dir}; 
        echo '-------------------------------------------------------------------------------------';
        echo '重启服务';
        /usr/local/nginx/sbin/nginx
        echo $(cat /usr/local/nginx/logs/error.log | grep notice | sort -r | sed -n '1,1p')
        echo '-------------------------------重启完毕------------------------------------------------------';
    else
        echo 'There is no such file：'${path};
    fi
