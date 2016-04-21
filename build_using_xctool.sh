#!/bin/bash

#计时
SECONDS=0

#假设脚本放置在与项目相同的路径下
project_path=$(pwd)
#取当前时间字符串添加到文件结尾
now=$(date +"%Y_%m_%d_%H_%M_%S")

#指定项目的scheme名称
scheme="DemoScheme"
#指定要打包的配置名
configuration="Adhoc"
#指定打包所使用的provisioning profile名称
provisioning_profile='AdHoc Profile'

#指定项目地址
workspace_path="$project_path/Demo.xcworkspace"
#指定输出路径
output_path="/Users/your_username/Documents/"
#指定输出归档文件地址
archive_path="$output_path/Demo_${now}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/Demo_${now}.ipa"
#获取执行命令时的commit message
commit_msg="$1"

#输出设定的变量值
echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===profile: ${provisioning_profile}==="
echo "===commit msg: $1==="

#先清空前一次build
xctool clean -workspace ${workspace_path} -scheme ${scheme} -configuration ${configuration}

#根据指定的项目、scheme、configuration与输出路径打包出archive文件
xctool build -workspace ${workspace_path} -scheme ${scheme} -configuration ${configuration} archive -archivePath ${archive_path}

#使用指定的provisioning profile导出ipa
#我暂时没找到xctool指定provisioning profile的方法，所以这里用了xcodebuild
xcodebuild -exportArchive -archivePath ${archive_path} -exportPath ${ipa_path} -exportFormat ipa -exportProvisioningProfile "${provisioning_profile}"

#上传到fir
fir publish ${ipa_path} -T fir_token -c "${commit_msg}"

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="
