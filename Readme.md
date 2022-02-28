# これは何？
タスク管理をきちんとやりたいと思い立ち、
今はやりのNotionを使うことにしました。

[こちらの記事](https://note.com/35d/n/n83c06af2dff2)のテンプレートを参考に、タスク管理テーブルを作成したところ、いい感じにタスク管理できそうなので、

会社に毎日出している日報をNotionAPIで出力してみました。

タスク管理用テーブルは　'Name':string　'ステータス':select　'カテゴリー':multi_select 'Date':Date　のカラムがあります。

'Name'にはタスク内容

'ステータス'には　タスクの現在のステータスで

'ToDo''InProgress''Pending''Outsource''Someday''Done'

'カテゴリー'にはそのタスクがどういう種類のタスクか、

'Date'には目標値が入っています。


出力内容は

1. ステータスが　'ToDo' or 'InProgress' or 'Outsource' かつ カテゴリーが'@仕事'
2. ステータスが  'Done'かつ　'Date'が 本日の日付

を出力し、その内容についてステータスが　かつ カテゴリーが'@仕事'

- 'ToDo'　であれば '未着手'

- 'InProgress' or 'Outsource' 　であれば '作業中'

- 'Done' であれば'完了'

と出力する。

※NotionのDBの複合Filterのネストが最大2つまでしか対応していないので、2つに分けてリクエストしている。