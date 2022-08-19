using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExcelAsset]
public class WeatherUranai : ScriptableObject
{
	public List<TestDataEntity> Sheet1; // Replace 'EntityType' to an actual type that is serializable.
	//public List<EntityType> Sheet1; // Replace 'EntityType' to an actual type that is serializable.
}
