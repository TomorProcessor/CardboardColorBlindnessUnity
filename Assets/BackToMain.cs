using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class BackToMain : MonoBehaviour
{
	private int count = 0;
	private bool isLookAt = false;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (isLookAt) count++;
		if (count == 150) SceneManager.LoadScene("Main", LoadSceneMode.Single);
    }
	
	public void onEnter() {
		isLookAt = true;
	}
	
	public void onLeave() {
		isLookAt = false;
		count = 0;
	}
}
