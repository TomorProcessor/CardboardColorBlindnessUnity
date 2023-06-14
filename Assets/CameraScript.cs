using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Android;

public class CameraScript : MonoBehaviour
{

    private bool camAvailable;
    WebCamTexture backCam;
    private Texture defaultBackground;

    public RawImage background;
    public AspectRatioFitter aspectRatio;
	private int count = 0;

    void Awake()
    {
        //Set up and enable the gyroscope (check your device has one)
        Input.gyro.enabled = true;
    }

    // Use this for initialization
    void Start()
    {
		if (!Permission.HasUserAuthorizedPermission(Permission.Camera))
        {
            Permission.RequestUserPermission(Permission.Camera);
        }

    }
	
	void initCamera() {
		defaultBackground = background.texture;
        WebCamDevice[] devices = WebCamTexture.devices;

        if (devices.Length == 0)
        {
            Debug.Log("no camera detected");
            camAvailable = false;
            return;
        }

        for (int i = 0; i < devices.Length; i++)
        {
            if (!devices[i].isFrontFacing)
            {
                backCam = new WebCamTexture(devices[i].name);
            }
            if (backCam == null)
            {
                Debug.Log("unable to find backCam");
                return;
            }
            backCam.Play();
            background.texture = backCam;
        }
	}

    // Update is called once per frame
    void Update()
    {
		if (count < 101) {
			count++;
			if (count == 100) initCamera();
		}
        if (!camAvailable)
        {
            return;
        }
        //transform.Rotate(-Input.gyro.rotationRateUnbiased.x, -Input.gyro.rotationRateUnbiased.y, -Input.gyro.rotationRateUnbiased.z);
        Debug.Log(SystemInfo.supportsGyroscope);
    }
}