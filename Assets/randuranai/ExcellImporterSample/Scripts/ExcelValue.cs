using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ExcelValue : MonoBehaviour
{
    [SerializeField] private WeatherUranai weatherUranai;
    [SerializeField] private Text weatherText; 

    private void Start()
    {
        for (int i = 1; i <= 10; i++)
        {
            weatherText.text += weatherUranai.Sheet1[i].text.ToString() + "\n";
        }






    }
}
