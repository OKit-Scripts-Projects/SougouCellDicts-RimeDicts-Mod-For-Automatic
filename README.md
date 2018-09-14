这是一个自动下载搜狗输入法的[细胞词库](http://pinyin.sogou.com/dict/)并转换为 `RIME` 词库的脚本。

# 运行说明
1. 文本编辑器打开配置`config`文件
2. 配置完成以后运行 `fetch.sh`，脚本退出以后，生成的词库文件就在`$Rime/$FILE_PREFIX` 里面了。
3. 每日更新热词，执行`daily.sh`
4. 重新布署


# 配置说明
## 配置方法
1.用文本编辑器打开 「config」 文件，

2.修改其中的路径。


## 前置条件
1.配置好
编辑 `输入法名.custom.yaml`

增加扩充词典
```yaml
patch:
  "translator/dictionary": 扩充词典名（不带后缀）
```


### 配置演示
1.config填写演示
```
#自定义配置：
GNU_SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" # 务必使用`gnu-sed`，「Mac用户」需用`brew`安装

##配置名称
USER_NAME="$(whoami)" # 「Rime使用者」用户名
SUB_DIR="luna_pinyin_cells" # 「放置`Rime细胞词库`的文件夹」名称
EXT_NAME="luna_pinyin.extended.dict.yaml" #「扩展词典」名称
DICT_PREFIX="luna_pinyin.cell" # 这个将作为「所有词典的名称」前缀，写在词典的内容里
FILE_PREFIX="luna_pinyin.cell" # 这个将作为「所有词典的文件名」前缀，以上两者可保持一样

# 生成文件路径，『Mac用户』不能更改！
RIME_DIR="/Users/$USER_NAME/Library/Rime" # 「Rime 文件夹」路径
EXT_PATH="$RIME_DIR/$EXT_NAME" # 「扩展词典路径」, 在对应`*.custome.yaml`中添加好的`"translator/dictionary"`字段
RIME_PATH="$RIME_DIR/$SUB_DIR" # 「放置`Rime细胞词库`的文件夹」路径
```
另外有一个选项 `HOOK_AFTER`，可以用于在脚本执行完成后执行自定义命令，比如自动重新部署RIME。

2.conf.d 内配置文件填写演示
```
#!/bin/bash
CELL_ID=`basename ${BASH_SOURCE[0]}`
DICT_CELL=("${DICT_CELL[@]}" $CELL_ID)
DICT=(

"搜狗标准词库/11640"
"搜狗标准大词库/11377"
"搜狗精选词库/11826"
"搜狗万能词库/11817"
"网络流行新词【官方推荐】/4"

)
eval "${CELL_ID}${DICT_CELL_SUFFIX}=(${DICT[@]})"
```

如
```
网络流行新词【官方推荐】.scel
https://pinyin.sogou.com/d/dict/download_cell.php?id=4&name=%E7%BD%91%E7%BB%9C%E6%B5%81%E8%A1%8C%E6%96%B0%E8%AF%8D%E3%80%90%E5%AE%98%E6%96%B9%E6%8E%A8%E8%8D%90%E3%80%91&f=detail
```
`网络流行新词【官方推荐】`就是词典名，url中的 `4` 就是 ID，

合成就是`"网络流行新词【官方推荐】/4"`




