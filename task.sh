#!bin/sh

#ステータスが　'ToDo' or 'InProgress' or 'Outsource' かつ カテゴリーが'@仕事'のタイトル名をplan.txtに出力
ANSWER1=$(curl -X POST  "https://api.notion.com/v1/databases/${DATABASE_ID}/query" \
  -sS \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2021-08-16" \
    --data '{
    "filter": {
        "and": [
                 {
                  "property": "カテゴリー",
                  "multi_select": {
                      "contains": "@仕事"
                    }
                  },
                {
                  "or": [
                    {
                        "property": "ステータス",
                        "select": {
                            "equals": "ToDo"
                        }
                    },
                    {
                        "property": "ステータス",
                        "select": {
                            "equals": "InProgress"
                        }
                    }
                ]
            }
        ]
    }
}' 

)
echo $ANSWER1 |jq -r '.results[].properties | .Name.title[].text.content' > plan.txt
echo $ANSWER1 |jq -r '.results[].properties | ."ステータス".select.name' | sed -e 's/ToDo/未着手/g' -e 's/InProgress/作業中/g' -e 's/Outsource/作業中/g' -e 's/Done/完了/g'  > result.txt


#ステータスが 'Done'かつ　'last_edited_time'が 本日の日付のものをplan.txtに追記
TODAY=$(date "+%Y-%m-%d")
#YESTERDAY=$(date "+%Y-%m-%d" -d '1 day ago')

ANSWER2=$(curl -X POST "https://api.notion.com/v1/databases/${DATABASE_ID}/query" \
  -sS \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2021-08-16" \
    --data '{
    "filter": {
        "and": [
                 {
                  "property": "ステータス",
                  "select": {
                              "equals": "Done"
                          }
                  },
                {
                  "property": "last_edited_time",
                  "date": {
                      "equals": "'$TODAY'"
                    }
                },{
                  "property": "カテゴリー",
                  "multi_select": {
                      "contains": "@仕事"
                    }
                }
              ]
            }
          }')

echo $ANSWER2 |jq -r '.results[].properties | .Name.title[].text.content' >> plan.txt     
echo $ANSWER2 |jq -r '.results[].properties | ."ステータス".select.name' | sed -e 's/ToDo/未着手/g' -e 's/InProgress/作業中/g' -e 's/Outsource/作業中/g' -e 's/Done/完了/g'  >>result.txt



# 行番号を項番としてつける。
nl plan.txt > plan2.txt
nl result.txt > result2.txt