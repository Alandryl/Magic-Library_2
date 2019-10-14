using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotationScript : MonoBehaviour {

    public float rotationSpeedX = 1;
    public float rotationSpeedY = 1;
    public float rotationSpeedZ = 1;

    // Use this for initialization
    void Start () {
		
	}

    // Update is called once per frame
    void Update()
    {
        // Rotate the object around its local X axis at 1 degree per second
        transform.Rotate(Vector3.right * Time.deltaTime * rotationSpeedX);
        transform.Rotate(Vector3.up * Time.deltaTime * rotationSpeedY);
        transform.Rotate(Vector3.forward * Time.deltaTime * rotationSpeedZ);


        // ...also rotate around the World's Y axis
        //transform.Rotate(Vector3.up * Time.deltaTime, Space.World);
    }
}
