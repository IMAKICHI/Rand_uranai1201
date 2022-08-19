using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TextContoroler : MonoBehaviour
{
    [SerializeField] int day_id;

    [SerializeField] string date_input;

    [SerializeField] GetWeatherCode weatherCode;

    [SerializeField] Text text;

    // Start is called before the first frame update
    void Start()
    {
        weatherCode = weatherCode.GetComponent<GetWeatherCode>();
        text = text.GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {
        text.text = day_id.ToString();
    }

    public void SetWetaher(string weatherCodes)
    {

    }

    public void SetDate(string date)
    {
        int year = int.Parse(date.Substring(0, 4));
        int month = int.Parse(date.Substring(5, 2));
        int day = int.Parse(date.Substring(8, 2));

        date_input = year.ToString() +"/"+ month.ToString()+"/" + day.ToString();

        int d_y = year - 2020;

        day_id = d_y * 365;

        if (year%4==0)//閏年
        {
            switch (month)
            {
                case 1:
                    day_id += 0;
                    break;
                case 2:
                    day_id += 31;
                    break;
                case 3:
                    day_id += 31 + 29;
                    break;
                case 4:
                    day_id += 31 + 29 + 31;
                    break;
                case 5:
                    day_id += 31 + 29 + 31 + 30;
                    break;
                case 6:
                    day_id += 31 + 29 + 31 + 30 + 31;
                    break;
                case 7:
                    day_id += 31 + 29 + 31 + 30 + 31 + 30;
                    break;
                case 8:
                    day_id += 31 + 29 + 31 + 30 + 31 + 30 + 31;
                    break;
                case 9:
                    day_id += 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31;
                    break;
                case 10:
                    day_id += 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30;
                    break;
                case 11:
                    day_id += 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31;
                    break;
                case 12:
                    day_id += 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30;
                    break;
                default:
                break;
            }
        }
        else
        {
            switch (month)
            {
                case 1:
                    day_id += 0;
                    break;
                case 2:
                    day_id += 31;
                    break;
                case 3:
                    day_id += 31 + 28;
                    break;
                case 4:
                    day_id += 31 + 28 + 31;
                    break;
                case 5:
                    day_id += 31 + 28 + 31 + 30;
                    break;
                case 6:
                    day_id += 31 + 28 + 31 + 30 + 31;
                    break;
                case 7:
                    day_id += 31 + 28 + 31 + 30 + 31 + 30;
                    break;
                case 8:
                    day_id += 31 + 28 + 31 + 30 + 31 + 30 + 31;
                    break;
                case 9:
                    day_id += 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31;
                    break;
                case 10:
                    day_id += 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30;
                    break;
                case 11:
                    day_id += 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31;
                    break;
                case 12:
                    day_id += 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30;
                    break;
                default:
                    break;
            }
        }

        day_id += day;

        



    }


}
