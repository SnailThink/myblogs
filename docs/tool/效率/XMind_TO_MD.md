## Xmind转为md格式



### 1.XMind转为md格式

#### 1.1 将Xmind文件导出为OPML格式

![image-20220630172956639](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220630172956639.png)

#### 1.2 Typora安装Pandoc

Typora 导入OPML 格式需要安装`Pandoc`

- 1. 操作文件导入



![image-20220630172903954](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220630172903954.png)



下载地址：https://github.com/jgm/pandoc/releases/tag/2.11.3.2

下载后缀为 .msi 的windows安装包，下载好后安装即可

![image-20220630173448331](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220630173448331.png)



**温馨提示:**

若访问github很慢可以从我的百度云盘下载

链接：https://pan.baidu.com/s/1Zy3vxfFh11jXBayMxStziQ?pwd=bw2q 
提取码：bw2q



- 2.检查是否安装成功:运行`cmd`输入`pandoc --help`如果安装不成功，将提示`pandoc`不是系统程序。安装成功，将出现帮助项



- 3.设置pandoc.exe 文件路径

​     文件默认路径在 `C:\Program Files\Pandoc\pandoc.exe`



- 4.操作导入opml文件：导入后效果如下所示

![image-20220630181601023](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220630181601023.png)

#### 1.3 使用Typora导入 opml 格式的文件

打开Typora, 点击 文件 -> 导入 -> 选择刚才导出的 opml 文件即可，导入后的效果如下





#### 1.4 pandoc的其他使用

Pandoc 支持非常多的格式；Pandoc 支持以下格式之间的转换（← 表示可以从该格式转换为其他格式； → 表示可以转换为该格式；↔︎ 表示支持该格式的双向转换）：

轻量级标记格式
↔︎ Markdown（包括 CommonMark 和GitHub-flavored Markdown）
↔︎ reStructuredText
→ AsciiDoc
↔︎ Emacs Org-Mode
↔︎ Emacs Muse
↔︎ Textile
← txt2tags

- HTML 格式
  - ↔︎ (X)HTML 4
  - ↔︎ HTML5

- Ebooks

  - ↔︎ EPUB 版本 2 或者版本 3
  - ↔︎ FictionBook2

- 文档格式

  - → GNU TexInfo
  - ↔︎ Haddock markup

- Roff 格式

  - ↔︎ roff man
  - → roff ms

- TeX 格式

  - ↔︎ LaTeX
  - → ConTeXt

- XML 格式

  - ↔︎ DocBook 版本 4 或者版本 5
  - ↔︎ JATS
  - → TEI Simple

- 大纲格式

  - ↔︎ OPML

- 数据格式

  - ← CSV 表格

- 文字处理格式

  - ↔︎ Microsoft Word docx
  - ↔︎ OpenOffice/LibreOffice ODT
  - → OpenDocument XML
  - → Microsoft PowerPoint

- 交互式笔记格式
  ↔︎ Jupyter notebook (ipynb)
  页面布局格式
  → InDesign ICML
  Wiki 标记语言格式
  ↔︎ MediaWiki 标记语
  ↔︎ DokuWiki 标记语
  ← TikiWiki 标记语
  ← TWiki 标记语
  ← Vimwiki 标记语
  → XWiki 标记语
  → ZimWiki 标记语
  ↔︎ Jira wiki 标记语
  幻灯片放映格式
  → LaTeX Beamer
  → Slidy
  → reveal.js
  → Slideous
  → S5
  → DZSlides
  自定义格式
  → 支持使用 lua 编写自定义转换器
  PDF
  → 通过 pdflatex、lualatex、xelatex、latexmk、tectonic、wkhtmltopdf、weasyprint、prince、context、pdfroff 插件或者工具转为为 PDF

  

[pandoc](https://pandoc.org/MANUAL.html)

#### 1.5 参考

[xmind格式转换成markdown](https://www.cnblogs.com/hi3254014978/p/14317868.html)

### 2.md转为XMind



#### 2.1 在Typora中将文件导出为OPML格式

![image-20220630174117624](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220630174117624.png)

#### 2.2 在XMind中导入OPML格式

- 导入后XMind效果如下所示

![image-20220630181822453](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220630181822453.png)