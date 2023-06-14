using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
	
	private static int count = 0;
	private static bool liveView = false;
	private static bool stillImage = false;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (liveView || stillImage) count++;
		if (count == 150) {
			if (liveView) SceneManager.LoadScene("LiveView", LoadSceneMode.Single);
			if (stillImage) SceneManager.LoadScene("Sphere", LoadSceneMode.Single);
		}
    }
	
	public void onLiveViewEnter() {
		liveView = true;
	}
	
	public void onStillImageEnter() {
		stillImage = true;
	}
	
	public void onLeave() {
		liveView = false;
		stillImage = false;
		count = 0;
	}
}
