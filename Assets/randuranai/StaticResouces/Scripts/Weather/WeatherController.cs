using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeatherController : MonoBehaviour
{
    [SerializeField] GameObject Cloud;

    [SerializeField] GameObject Rain;

    [SerializeField] GameObject Snow;

    [SerializeField] SampleSceneController sample;

    public int Codes;

    public float span = 3f;
    
    // Start is called before the first frame update
    void Start()
    {
        //sample = sample.GetComponent<SampleSceneController>();
        SetDefault();
        //Codes = sample.weatherCodes;
        //StartCoroutine("GetCodes");
    }

    IEnumerator GetCodes()
    {
        while (true)
        {
            yield return new WaitForSeconds(span);
            Codes = sample.weatherCodes;
        }
    }

    // Update is called once per frame
    void Update()
    {


        if (100 <= Codes && Codes < 200)
        {
            SetDefault();

            //晴
        }
        else if (200 <= Codes && Codes < 300)
        {
            //曇
            Cloud.SetActive(true);

            Rain.SetActive(false);

            Snow.SetActive(false);

        }
        else if (300 <= Codes && Codes < 400)
        {
            //雨
            Rain.SetActive(true);
            Cloud.SetActive(true);

            Snow.SetActive(false);

        }
        else if (400 <= Codes && Codes < 500)
        {
            //雪
            Snow.SetActive(true);
            Cloud.SetActive(true);
            Rain.SetActive(false);

        }
    }

    void SetDefault()
    {
        Cloud.SetActive(false);
        Rain.SetActive(false);
        Snow.SetActive(false);
    }



    public void SetCodes(int WeatherCode)
    {
        Codes = WeatherCode;
    }
}
