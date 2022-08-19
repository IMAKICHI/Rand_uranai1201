using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class BezierLineRendererScript : MonoBehaviour
{
    [SerializeField] float width = 1f;

    public Transform trans1;
    public Transform trans2;
    
    [SerializeField] int middlePoints = 10;
    [SerializeField] Vector3 controlPoint = new Vector3(0, 2, 0);

    public bool considerDistance = false;
    public float distanceEffect = 0.2f;

    LineRenderer render;

    // Use this for initialization
    void Start()
    {
        render = GetComponent<LineRenderer>();
    }

    void Update()
    {

        var de = 1.0f;
        if (considerDistance)
        {
            de = (trans1.position - trans2.position).magnitude * distanceEffect;
        }
        var control = (trans1.position + trans2.position) / 2 + controlPoint * de;

        var totalPoints = middlePoints + 2;
        render.positionCount = totalPoints;

        render.SetPosition(0, trans1.position);
        for (int i = 1; i <= middlePoints; i++)
        {
            var t = (float)i / (float)(totalPoints - 1);
            var mpos = SampleCurve(trans1.position, trans2.position, control, t);
            render.SetPosition(i, mpos);
        }

        render.startWidth = width;
        render.endWidth = width;

        render.SetPosition(totalPoints - 1, trans2.position);

    }

    //https://developer.oculus.com/blog/teleport-curves-with-the-gear-vr-controller/
    Vector3 SampleCurve(Vector3 start, Vector3 end, Vector3 control, float t)
    {
        // Interpolate along line S0: control - start;
        Vector3 Q0 = Vector3.Lerp(start, control, t);
        // Interpolate along line S1: S1 = end - control;
        Vector3 Q1 = Vector3.Lerp(control, end, t);
        // Interpolate along line S2: Q1 - Q0
        Vector3 Q2 = Vector3.Lerp(Q0, Q1, t);
        return Q2; // Q2 is a point on the curve at time t
    }
}