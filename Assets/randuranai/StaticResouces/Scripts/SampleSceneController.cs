using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class SampleSceneController : MonoBehaviour
{
    [SerializeField] private Button button;
    [SerializeField] InputField input;
    [SerializeField] Text Text;

    string areacode;
    [SerializeField] string URL = "https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json";

    public int weatherCodes;


    // Start is called before the first frame update
    void Start()
    {
        input = input.GetComponent<InputField>();
        Text = Text.GetComponent<Text>();
        button?.onClick.AddListener(OnClickedButton);
    }

    private void OnClickedButton()
    {
        areacode = input.text;
        URL = "https://www.jma.go.jp/bosai/forecast/data/forecast/" + areacode + ".json";
        StartCoroutine(GetRequest(URL));
    }


    private IEnumerator GetRequest(string uri)
    {
        using (UnityWebRequest webRequest = UnityWebRequest.Get(uri))
        {
            // Request and wait for the desired page.
            yield return webRequest.SendWebRequest();

            if (webRequest.isHttpError)
            {
                // レスポンスコードを見て処理
                Debug.Log($"[Error]Response Code : {webRequest.responseCode}");
            }
            else if (webRequest.isNetworkError)
            {
                // エラーメッセージを見て処理
                Debug.Log($"[Error]Message : {webRequest.error}");
            }
            //Debug.Log(webRequest.downloadHandler.text);


            var data = new ResponceData();
            var json = "{" + $"\"root\": {webRequest.downloadHandler.text}" + "}";
            JsonUtility.FromJsonOverwrite(json, data);
            var response = JsonUtility.FromJson<Response>(json);


            string tenki = "";

            //weatherCodes
            weatherCodes = int.Parse(response.root[0].timeSeries[0].areas[0].weatherCodes[0]);
            string area = response.root[0].timeSeries[0].areas[0].area.name;
            string date = response.root[0].reportDatetime;

            int year = int.Parse(date.Substring(0, 3));
            int month = int.Parse(date.Substring(5, 2));
            int day = int.Parse(date.Substring(8, 2));


            if (100 <= weatherCodes && weatherCodes < 200)
            {
                tenki = "晴れですよ～";
            }
            else if (200 <= weatherCodes && weatherCodes < 300)
            {
                tenki = "曇りですよ～";
            }
            else if (300 <= weatherCodes && weatherCodes < 400)
            {
                tenki = "雨ですよ～";
            }
            else if (400 <= weatherCodes && weatherCodes < 500)
            {
                tenki = "雪ですよ～";
            }


            Text.text = "今日の日付は" + year + "/" + month + "/" + day + "\n"
                        + area + "の今日の天気は..." + tenki + "\n"
                        + "今日の占命は";




            /*
            Debug.Log("データ配信元: " + response.publishingOffice);
            Debug.Log("報告日時: " + response.reportDatetime);
            Debug.Log("対象の地域: " + response.targetArea);
            
            Debug.Log("今日の天気: " + response.today);
            Debug.Log("明日の天気: " + response.tomorrow);

            Debug.Log("ヘッドライン: " + response.headlineText);
            Debug.Log("詳細: " + response.text);

            Text.text = "データ配信元: " + response.publishingOffice + "\n"+
                        "報告日時: " + response.reportDatetime + "\n" +
                        "対象の地域: " + response.targetArea + "\n" +
                        "詳細: " + response.text + "\n" 
                        ;
            */


            yield return null;
        }
    }
}
/*

[System.Serializable]
public class Area
{
    public string name;
    public string code;

    public Area(string name, string code)
    {
        this.name = name;
        this.code = code;
    }
    public override string ToString()
    {
        return string.Format("{0}, {1}, {2}", name, code);
    }
}

[System.Serializable]
public class timeDefines
{
    public string[] timeDefine;
}

[System.Serializable]
public class areas
{
    public Area area;
    public string[] weathers;
    public string[] weatherCodes;

}

[System.Serializable]
public class timeSeries
{
    public string[] timeDefines;
    public areas[] areas;
}


[System.Serializable]

public class Root
{
    public string publishingOffice;
    public string reportDatetime;
    public string targetArea;
    public string headlineText;
    public string text;
    public timeSeries[] timeSeries;
    public string tomorrow;
}

[System.Serializable]

public class Response
{
    public Root[] root;
    
}

[System.Serializable] 
public class ResponceData
{
    public Response[] root;
}
*/