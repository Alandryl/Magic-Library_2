using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightFlicker : MonoBehaviour
{
    public float duration = 1.0f;
    public Color lightMin, lightMax;
    public float t = 0.5f;

    Light lt;

    void Start()
    {
        lt = GetComponent<Light>();
    }

    void Update()
    {
        t += Random.Range(-1f, 1f) * Time.deltaTime;
        t = Mathf.Clamp(t, 0, 1);
        lt.color = Color.Lerp(lightMin, lightMax, t);
    }
}

