\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{xum_review}[2024/01/01 Xiamen University Malaysia Review Template]

% 基于article类
\LoadClass[a4paper,12pt]{article}

% 必需的包
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{setspace}
\RequirePackage{parskip}
\RequirePackage{xurl}  % 增强的 URL 包，支持更好的断行
\RequirePackage{pdflscape}  % 支持横向页面
\RequirePackage{tocloft}
\RequirePackage[htt]{hyphenat}  % 启用等宽字体的自动断行
\RequirePackage[natbibapa]{apacite}
\RequirePackage{etoolbox}
\RequirePackage{lastpage}
\RequirePackage[colorlinks=true,linkcolor=black,citecolor=black,urlcolor=cyan]{hyperref}

% 超链接设置
\hypersetup{
    bookmarks=true,
    pdftitle={Review},
    pdfauthor={Xiamen University Malaysia}
}

% ==========================================
% 解决 texttt 溢出问题的配置
% ==========================================
% 方案1: hyphenat 包的 htt 选项（已在上面加载）
% 这会让所有 \texttt{} 和 \ttfamily 文本可以自动断行

% 方案2: 配置 xurl 的断行规则，定义 \code{} 命令
% 允许在更多位置断行：下划线、逗号、括号、斜杠等
\def\UrlBreaks{\do\.\do\@\do\\\do\/\do\!\do\_\do\|\do\;\do\>%
  \do\]\do\)\do\,\do\?\do\'\do+\do\=\do\#\do\(\do\[}

% 定义 \code{} 命令作为 \texttt{} 的可断行替代
% 使用方法：\code{长文本} - 会在合适位置自动断行
\newcommand{\code}[1]{{\ttfamily\path{#1}}}

% 页面设置
\geometry{
    top=2.5cm,
    bottom=2.5cm,
    left=2.5cm,
    right=2.5cm,
    headheight=15pt
}

% 页眉页脚设置
\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{XIAMEN UNIVERSITY MALAYSIA}
\fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% 首页样式
\fancypagestyle{plain}{
    \fancyhf{}
    \fancyhead[C]{XIAMEN UNIVERSITY MALAYSIA}
    \fancyfoot[C]{}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}

% 行距设置为1.5倍
\onehalfspacing

% 段落设置 - 段首不缩进，使用段落间距分段
\setlength{\parskip}{0.5\baselineskip}
\setlength{\parindent}{0pt}

% 标题格式设置
\renewcommand{\maketitle}{
    \begin{center}
        {\LARGE\bfseries\@title\par}
        \vspace{1em}
        {\large\@author\par}
        \vspace{0.5em}
        {\large\@date\par}
    \end{center}
    \vspace{2em}
}

% 目录格式
\renewcommand{\contentsname}{Contents}

% 目录中的点线设置
\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsubsecleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsubsubsecleader}{\cftdotfill{\cftdotsep}}

% 调整目录缩进以适应 "Task X" 格式
% section: 不缩进(0em)，编号宽度4em以容纳"Task X"
% subsection: 缩进4em(等于section编号宽度)，编号宽度3em以容纳"X.X"
% subsubsection: 缩进7em(section宽度+subsection宽度)，编号宽度4em以容纳"X.X.X"
\cftsetindents{section}{0em}{4em}
\cftsetindents{subsection}{2em}{2em}
\cftsetindents{subsubsection}{4em}{4em}

% 引用格式设置
\bibliographystyle{apacite}
\renewcommand{\refname}{References}

% 将References添加到目录
\renewcommand{\bibsection}{\section*{\refname}\addcontentsline{toc}{section}{\refname}}

% 修改section编号格式为 "Task X"
\renewcommand{\thesection}{Task \arabic{section}}

% 修改subsection编号格式，保持纯数字 "X.X"
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}}

% 节标题格式
\renewcommand{\section}{\@startsection{section}{1}{\z@}%
    {-3.5ex \@plus -1ex \@minus -.2ex}%
    {2.3ex \@plus.2ex}%
    {\normalfont\Large\bfseries}}

\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
    {-3.25ex\@plus -1ex \@minus -.2ex}%
    {1.5ex \@plus .2ex}%
    {\normalfont\large\bfseries}}

\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
    {-3.25ex\@plus -1ex \@minus -.2ex}%
    {1.5ex \@plus .2ex}%
    {\normalfont\normalsize\bfseries}}

% 图表标题格式
\RequirePackage{caption}
\captionsetup{
    font=small,
    labelfont=bf,
    textfont=it,
    margin=10pt
}

% 设置图片编号为章节.序号格式
\renewcommand{\thefigure}{\thesection.\arabic{figure}}
% 设置表格编号为章节.序号格式
\renewcommand{\thetable}{\thesection.\arabic{table}}

% 确保每个section开始时重置图表计数器
\@addtoreset{figure}{section}
\@addtoreset{table}{section}

% 额外需要的包
\RequirePackage{titlesec}
\RequirePackage{csquotes}
\RequirePackage{listings}
\RequirePackage{xcolor}
\RequirePackage{float}
\RequirePackage{graphicx}
\RequirePackage{amsmath}
\RequirePackage{adjustbox}
\RequirePackage{cleveref}
\RequirePackage{fontspec}
\RequirePackage{pdfpages}
\RequirePackage{longtable}
\RequirePackage{booktabs}

% XeLaTeX字体支持
\setmonofont{Consolas}[Scale=0.9]

% 代码格式 - Python
\lstnewenvironment{python}[1][]{
	\vspace{0.5em}
	\noindent
	\colorbox[RGB]{232,232,232}{%
		\begin{minipage}{0.979\textwidth}
		\vspace{0.2em}
		\hspace{0.8em}
		\includegraphics[height=0.9em]{figure/assets/py_logo.png}%
		\hspace{0.5em}%
		\color[RGB]{88,88,88}%
		\textbf{\textsf{Python}}%
		\vspace{0.2em}
		\end{minipage}
	}
	\vspace{-1.65em}
	\lstset{
		language=Python,
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\ttfamily\color[RGB]{130,130,130},
		numbersep=5pt,
		frame=none,
		framesep=0pt,
		xleftmargin=0pt,
		framexleftmargin=0pt,
		backgroundcolor=\color[RGB]{245,245,245},
		breaklines=true,
		breakindent=10pt,
		keywordstyle=\color[RGB]{255,119,0},
		morekeywords={as, self},
		deletekeywords={print},
		keywordstyle=[2]\color[RGB]{144,0,144},
		morekeywords=[2]{print},
		stringstyle=\color[RGB]{0,170,0},
		commentstyle=\color[RGB]{221,0,0},
		showstringspaces=false,
		#1
	}
}{}

% SQL代码格式
\lstnewenvironment{sql}[1][]{
	\noindent
	\lstset{
		language=SQL,
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\ttfamily\color[RGB]{130,130,130},
		numbersep=5pt,
		frame=none,
		framesep=0pt,
		xleftmargin=0pt,
		framexleftmargin=0pt,
		backgroundcolor=\color[RGB]{245,245,245},
		breaklines=true,
		breakindent=10pt,
		keywordstyle=\color[RGB]{255,119,0},
		morekeywords={EXPLAIN, ANALYZE, PARTITION, OVER, WINDOW, LATERAL, MATERIALIZED, ORDINALITY},
		keywordstyle=[2]\color[RGB]{144,0,144},
		morekeywords=[2]{COUNT, SUM, AVG, MAX, MIN, DISTINCT, CAST, COALESCE, NULLIF, CASE, WHEN, THEN, ELSE, END},
		keywordstyle=[3]\color[RGB]{0,102,204},
		morekeywords=[3]{TEXT, INTEGER, BIGINT, SERIAL, VARCHAR, CHAR, DATE, TIME, TIMESTAMP, BOOLEAN, NUMERIC, DECIMAL, REAL, DOUBLE},
		stringstyle=\color[RGB]{0,170,0},
		commentstyle=\color[RGB]{221,0,0},
		showstringspaces=false,
		#1
	}
}{}

% JSON代码格式
\lstnewenvironment{json}[1][]{
	\vspace{0.5em}
	\noindent
	\colorbox[RGB]{232,232,232}{%
		\begin{minipage}{0.979\textwidth}
		\vspace{0.2em}
		\hspace{0.8em}
		\includegraphics[height=0.9em]{figure/assets/json_logo.png}%
		\hspace{0.5em}%
		\color[RGB]{88,88,88}%
		\textbf{\textsf{JSON}}%
		\vspace{0.2em}
		\end{minipage}
	}
	\vspace{-1.65em}
	\lstset{
		language=,
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\ttfamily\color[RGB]{130,130,130},
		numbersep=5pt,
		frame=none,
		framesep=0pt,
		xleftmargin=0pt,
		framexleftmargin=0pt,
		backgroundcolor=\color[RGB]{245,245,245},
		breaklines=true,
		breakindent=10pt,
		stringstyle=\color[RGB]{0,170,0},
		keywordstyle=\color[RGB]{0,0,255},
		commentstyle=\color[RGB]{221,0,0},
		literate=
		{:}{{{\color[RGB]{255,119,0}{:}}}}{1}
		{,}{{{\color[RGB]{255,119,0}{,}}}}{1}
		{\{}{{{\color[RGB]{0,0,255}{\{}}}}{1}
		{\}}{{{\color[RGB]{0,0,255}{\}}}}}{1}
		{[}{{{\color[RGB]{0,0,255}{[}}}}{1}
		{]}{{{\color[RGB]{0,0,255}{]}}}}{1}
		{true}{{{\color[RGB]{144,0,144}{true}}}}{4}
		{false}{{{\color[RGB]{144,0,144}{false}}}}{5}
		{null}{{{\color[RGB]{144,0,144}{null}}}}{4},
		showstringspaces=false,
		morestring=[b]",
		morestring=[b]',
		#1
	}
}{}

% CMD代码格式
\lstnewenvironment{cmd}[1][]{
	\vspace{0.5em}
	\noindent
	\colorbox[RGB]{232,232,232}{%
	\begin{minipage}{0.914\textwidth}
		\vspace{0.2em}
		\hspace{0.8em}
		\includegraphics[height=0.9em]{figure/assets/WIndows-Terminal-icon.png}%
		\hspace{0.5em}%
		\color[RGB]{88,88,88}%
		\textbf{\textsf{Windows Command Prompt}}%
		\vspace{0.2em}
		\end{minipage}
	}
	\vspace{-2em}
	\lstset{
		language=command.com,
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\ttfamily\color[RGB]{170,170,170},
		numbersep=5pt,
		frame=none,
		framesep=0pt,
		xleftmargin=0pt,
		framexleftmargin=0pt,
		backgroundcolor=\color[RGB]{245,245,245},
		breaklines=true,
		breakindent=10pt,
		stringstyle=\color[RGB]{255,255,0},
		keywordstyle=\color[RGB]{0,255,255},
		commentstyle=\color[RGB]{0,170,0},
		showstringspaces=false,
		morestring=[b]",
		morestring=[b]',
		#1
	}
}{}

% HTML代码格式
\lstnewenvironment{html}[1][]{
	\vspace{0.5em}
	\noindent
	\colorbox[RGB]{232,232,232}{%
		\begin{minipage}{0.979\textwidth}
		\vspace{0.2em}
		\hspace{0.8em}%
		\includegraphics[height=1em]{figure/assets/html_logo.png}%
		\hspace{0.5em}%
		\color[RGB]{88,88,88}%
		\textbf{\textsf{HTML}}%
		\vspace{0.2em}
		\end{minipage}
	}
	\vspace{-1.65em}
	\lstset{
		language=HTML,
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\ttfamily\color[RGB]{130,130,130},
		numbersep=5pt,
		frame=none,
		framesep=0pt,
		xleftmargin=0pt,
		framexleftmargin=0pt,
		backgroundcolor=\color[RGB]{245,245,245},
		breaklines=true,
		breakindent=10pt,
		keywordstyle=\color[RGB]{0,0,255},
		stringstyle=\color[RGB]{0,170,0},
		commentstyle=\color[RGB]{221,0,0},
		identifierstyle=\color[RGB]{255,119,0},
		showstringspaces=false,
		tabsize=2,
		#1
	}
}{}

% JavaScript代码格式
\lstnewenvironment{javascript}[1][]{
	\vspace{0.5em}
	\noindent
	\colorbox[RGB]{232,232,232}{%
		\begin{minipage}{0.979\textwidth}
		\vspace{0.2em}
		\hspace{0.8em}
		\includegraphics[height=1em]{figure/assets/js_logo.png}%
		\hspace{0.5em}%
		\color[RGB]{88,88,88}%
		\textbf{\textsf{JavaScript}}%
		\vspace{0.2em}
		\end{minipage}
	}
	\vspace{-1.65em}
	\lstset{
		language=Java,
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\ttfamily\color[RGB]{130,130,130},
		numbersep=5pt,
		frame=none,
		framesep=0pt,
		xleftmargin=0pt,
		framexleftmargin=0pt,
		backgroundcolor=\color[RGB]{245,245,245},
		breaklines=true,
		breakindent=10pt,
		keywordstyle=\color[RGB]{144,0,144},
		keywordstyle=[2]\color[RGB]{255,119,0},
		morekeywords={var,let,const,function,return,if,else,for,while,do,switch,case,break,continue,try,catch,finally,throw,new,this,typeof,instanceof,in,of,async,await,class,extends,super,static,import,export,default,from,as},
		morekeywords=[2]{console,document,window,alert,prompt,confirm,getElementById,createElement,appendChild,addEventListener,fetch,Promise,JSON,Array,Object,String,Number,Boolean,Date,RegExp,Math,parseInt,parseFloat,isNaN,setTimeout,setInterval,clearTimeout,clearInterval},
		stringstyle=\color[RGB]{0,170,0},
		commentstyle=\color[RGB]{221,0,0},
		identifierstyle=\color[RGB]{0,0,0},
		showstringspaces=false,
		tabsize=2,
		morecomment=[l]{//},
		morecomment=[s]{/*}{*/},
		morestring=[b]",
		morestring=[b]',
		morestring=[b]`,
		#1
	}
}{}

% 通用代码环境
\newcommand{\codeheader}[1]{%
	\vspace{0.5em}
	\noindent
	\colorbox[RGB]{248,249,250}{%
		\begin{minipage}{\textwidth}
		\vspace{0.2em}
		\hspace{0.8em}
		\color[RGB]{88,88,88}%
		\textbf{\textsf{#1}}%
		\vspace{0.2em}
		\end{minipage}
	}
	\vspace{-0.1em}
}

\lstnewenvironment{codewithheader}[2][]{
	\codeheader{#2}
	\lstset{
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\tiny\color{gray},
		numbersep=8pt,
		frame=single,
		framerule=0.5pt,
		frameround=ffff,
		rulecolor=\color[RGB]{229,230,232},
		framesep=2pt,
		xleftmargin=0pt,
		framexleftmargin=2pt,
		backgroundcolor=\color[RGB]{255,255,255},
		breaklines=true,
		breakindent=10pt,
		keywordstyle=\color[RGB]{255,119,0},
		stringstyle=\color[RGB]{0,170,0},
		commentstyle=\color[RGB]{221,0,0},
		showstringspaces=false,
		#1
	}
}{}

\lstnewenvironment{htmlcssjs}[1][]{
	\vspace{0.5em}
	\noindent
	\colorbox[RGB]{232,232,232}{%
		\begin{minipage}{0.979\textwidth}
		\vspace{0.2em}
		\hspace{0.8em}
		\includegraphics[height=0.9em]{figure/assets/html_css_js_logo.png}%
		\hspace{0.5em}%
		\color[RGB]{88,88,88}%
		\textbf{\textsf{HTML CSS JavaScript}}%
		\vspace{0.2em}
		\end{minipage}
	}
	\vspace{-1.65em}
	\lstset{
		language=HTML,
		basicstyle=\ttfamily\footnotesize,
		numbers=left,
		numberstyle=\ttfamily\color[RGB]{130,130,130},
		numbersep=5pt,
		frame=none,
		framesep=0pt,
		xleftmargin=0pt,
		framexleftmargin=0pt,
		backgroundcolor=\color[RGB]{245,245,245},
		breaklines=true,
		breakindent=10pt,
		keywordstyle=\color[RGB]{0,0,255},
		stringstyle=\color[RGB]{0,170,0},
		commentstyle=\color[RGB]{221,0,0},
		identifierstyle=\color[RGB]{255,119,0},
		showstringspaces=false,
		tabsize=2,
		#1
	}
}{}

\endinput 