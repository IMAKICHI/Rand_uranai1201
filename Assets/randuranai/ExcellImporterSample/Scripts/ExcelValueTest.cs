using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ExcelValueTest : MonoBehaviour
{
    [SerializeField] test test;
    [SerializeField] Text nameText; // 表示するモンスターの名前のテキスト

    private void Start()
    {
        // 表示のテキストをモンスターの名前（リストの1番はじめの）に変える
        nameText.text = test.Sheet1[0].id.ToString();
        nameText.text += test.Sheet1[1].id.ToString();
        nameText.text += test.Sheet1[2].id.ToString();
        nameText.text += test.Sheet1[3].id.ToString();
        nameText.text += test.Sheet1[4].id.ToString();

        nameText.text += "\n";

        nameText.text += test.Sheet1[0].text.ToString();
        nameText.text += "\n";

        nameText.text += test.Sheet1[1].text.ToString();
        nameText.text += "\n";

        nameText.text += test.Sheet1[2].text.ToString();
        nameText.text += "\n";

        nameText.text += test.Sheet1[3].text.ToString();
        nameText.text += "\n";

        nameText.text += test.Sheet1[4].text.ToString();





    }
}
