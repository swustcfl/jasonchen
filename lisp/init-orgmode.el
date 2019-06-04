;;必须是列表否则会报错
(setq org-agenda-files '("~/Google 云端硬盘/org/agenda"))
(setq org-bullets-bullet-list '("☰" "☷" "☯" "☭"))

;; 指定org-capture的默认位置，可以用来记录临时的事情
(setq org-default-notes-file "~/Google 云端硬盘/org/capture.org")

;; 指定org-capture模板，company(记录公司相关事物)
(setq org-capture-templates nil)
(add-to-list 'org-capture-templates '("c" "Company Things!"))
;;-----------------------------
;;diary的一级标题是客户名字(便于计算时间)，这样company可以refile到diary上，diary 也可以refile到company上

;;


;;公司主要分 支持， 文档，项目，测试
;;支持
;;下面属性都是动态的
;;属性：日志的路径 - (遗留问题增加这个属性 命令org-set-property)
;;        日志路径要好好构造一下,然后在archive的时候可以删掉,或者移动到另一个目录上
;;           日志上层目录是客户名，下层是年月日
;;属性：版本(bug修复的版本，如果有bug的话用命令加这个属性)
;;属性：测试进度(如果有bug的话)
;;属性：Address 奇妙清单地址，禅道其他相关的地址
;;属性：客户的重要性
;;属性：block原因
(add-to-list 'org-capture-templates
             '("cs" "Support work" entry
               (file+olp "~/Google 云端硬盘/org/agenda/company.org" "Support")
"* TODO %^g - %^{title} %^g
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :LogPath: 
   :Version: 
   :Address: 
   :END:%^{Importance}p
   %^{Process}p
   %^{BlockReason}p
%?"
:empty-lines 1))

;;文档 cd
;;固定属性：进度
;;属性：修改业务
;;属性：上线时间
(add-to-list 'org-capture-templates
             '("cd" "Documents" entry
               (file+olp "~/Google 云端硬盘/org/agenda/company.org" "Documents")
"* TODO  %^{title} 
   SCHEDULED: %^T DEADLINE: %^t
  :PROPERTIES:
  :Created: %t
  :END:%^{Function}p
  %^{OnlineTime}p
  %^{Process}p
修改点: %?"
:empty-lines 1))

;;待定
;;项目 cp
;;属性：具体项目管理的地址(需求管理，需求开发，技术架构等文档目录)
;;属性：进度阶段
;;属性：项目开始时间(SCHEDULED) 项目结束时间(DEADLINE)
;;属性：blockreason
;;属性：Address记录禅道等地址
;;属性：block原因
(add-to-list 'org-capture-templates
             '("cp" "Project" entry
               (file+olp "~/Google 云端硬盘/org/agenda/company.org" "Project")
"* TODO %^g - %^{title} %^g
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :Address: 
   :END:%^{Process}p
   %^{BlockReason}p
%?"
:empty-lines 1))

;;测试 ct
;;属性：进度
;;属性：测试排期
;;属性：用链接记录禅道地址
(add-to-list 'org-capture-templates
             '("ct" "Test" entry
               (file+olp "~/Google 云端硬盘/org/agenda/company.org" "Test")
"* TODO %^g - %^{title} %^g
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :TestSchedule:
   :TestAddr: 
   :END:%^{Process}p
%?"
:empty-lines 1))

;;个人分为 阅读，代码，笔记blog 家庭 游戏 健身
(add-to-list 'org-capture-templates '("p" "Personal Things!"))
;; Category:哪种类型的书籍
;; OnlineAddr:购买地址
;; Pages:总页数，用来计划每天看几页
;; Current: 当前页
;; notebook：笔记地址
(add-to-list 'org-capture-templates
             '("pr" "Personal Reading Book Task" entry
               (file+olp "~/Google 云端硬盘/org/agenda/personal.org" "ReadingBook")
"* TODO %^{title}
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :END:%^{Category}p
   %^{OnlineAddr}p
   %^{Pages}p
   %^{Current}p
%?"
:empty-lines 1))

;;coding
;;属性：DesignAddr：设计相关图纸地址
;;属性：FunctionIntro实现功能描述
;;属性：Reference 参考地址
(add-to-list 'org-capture-templates
             '("pc" "Personal Coding" entry
               (file+olp "~/Google 云端硬盘/org/agenda/personal.org" "Coding")
"* TODO %^{title}
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :END:%^{DesignAddr}p
   %^{FunctionIntro}p
   %^{Reference}p
%?"
:empty-lines 1))

;;blog
;;属性：Topic 主题
;;属性：BlogAddr 笔记地址
;;属性：Reference 参考
(add-to-list 'org-capture-templates
             '("pb" "Personal Blog" entry
               (file+olp "~/Google 云端硬盘/org/agenda/personal.org" "Blog")
"* TODO %^{title}
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :END:%^{BlogAddr}p
   %^{Topic}p
   %^{Reference}p
%?"
:empty-lines 1))

;;家庭
;;建议每两周出去一趟玩玩
;;位置 + 攻略
(add-to-list 'org-capture-templates
             '("ph" "Personal Home" entry
               (file+olp "~/Google 云端硬盘/org/agenda/personal.org" "Home")
"* TODO %^{title}
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :END:
%?"
:empty-lines 1))

;;健身
;;跟这个keep还是体感游戏的安排
(add-to-list 'org-capture-templates
             '("pf" "Personal Fitness" entry
               (file+olp "~/Google 云端硬盘/org/agenda/personal.org" "Fitness")
"* TODO %^{title}
   SCHEDULED: %^T DEADLINE: %^t
   :PROPERTIES:
   :Created: %t
   :END:
%?"
:empty-lines 1))

;; 用来记录每日临时的事情
;; 比如一周内网上看到的临时网页 - 建议每周的三 五晚上做好消化吸收
;; 任何杂事
(add-to-list 'org-capture-templates
             '("j" "Journal" entry (file "~/Google 云端硬盘/org/agenda/journal.org")
               "* %U - %^{heading}\n  %?"))

;;将org 拷贝到beorg里 空闲半小时copy一次
(defun copy-to-beorg ()
  (interactive)
  (my-async-shell-command "cp -rf ~/Google\\ 云端硬盘/org ~/Library/Mobile\\ Documents/iCloud~com~appsonthemove~beorg/Documents/"))
(run-with-idle-timer 1800 t
                     #'copy-to-beorg)
(provide 'init-orgmode)
