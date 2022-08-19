using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable] // このアトリビュートの追加必要
public class TestDataEntity //  : MonoBehaviourは付けない
{
    // publicでExcelデータの1行目と同じパラメータ
    public int id;
    public string text;
}