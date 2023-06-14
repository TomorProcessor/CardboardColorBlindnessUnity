using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class ToggleShader : MonoBehaviour
{
    private static bool isShaderOn = false;
    private static bool isDaltonized = true;
    private static bool isSimulated = false;
    public GameObject background;
    public Shader protanopeDalton;
    public Shader deuteranopeDalton;
    public Shader tritanopeDalton;
	public Shader protanopeSimul;
    public Shader deuteranopeSimul;
    public Shader tritanopeSimul;
	public TextMeshPro infoText;
    private Shader currentShader;
    private int count = 0;
    private static bool onToggle = false;
    private static bool onProtanope = false;
    private static bool onDeuteranope = false;
    private static bool onTritanope = false;
	private static bool onSwitch = false;
	private static String lastShader;
    private Shader originalShader;
	public String menuName;

    // Start is called before the first frame update
    void Start()
    {
		Debug.Log("START");
        originalShader = background.GetComponent<RawImage>().material.shader;
		currentShader = protanopeDalton;
		lastShader = "protanope";
		updateInfoText();
    }

    // Update is called once per frame
    void Update()
    {
        if (onToggle || onProtanope || onDeuteranope || onTritanope || onSwitch)
        {
            if (onToggle && menuName == "toggle")count++;
            if (onProtanope && menuName == "protanope")count++;
            if (onDeuteranope && menuName == "deuteranope")count++;
            if (onTritanope && menuName == "tritanope")count++;
            if (onSwitch && menuName == "switch")count++;
        }
        if (count == 150)
        {
			if (!onProtanope && !onDeuteranope && !onTritanope) {
				if (lastShader == "protanope") onProtanope = true;
				if (lastShader == "deuteranope") onDeuteranope = true;
				if (lastShader == "tritanope") onTritanope = true;
			}
			if (onSwitch) {
				if (isDaltonized) {
					isDaltonized = false;
					isSimulated = true;
				} else {
					isDaltonized = true;
					isSimulated = false;
				}
			}
            if (isDaltonized)
            {
                if (onProtanope)
                {
                    currentShader = protanopeDalton;
					lastShader = "protanope";
					Debug.Log("protanope dalton set");
					
                }
                if (onDeuteranope)
                {
                    currentShader = deuteranopeDalton;
					lastShader = "deuteranope";
					Debug.Log("deuteranope dalton set");
                }
                if (onTritanope)
                {
                    currentShader = tritanopeDalton;
					lastShader = "tritanope";
					Debug.Log("tritanope dalton set");
                }
                background.GetComponent<RawImage>().material.shader = currentShader;
            }
            if (isSimulated)
            {
				if (onProtanope)
                {
                    currentShader = protanopeSimul;
					lastShader = "protanope";
					Debug.Log("protanope simul set");
                }
                if (onDeuteranope)
                {
                    currentShader = deuteranopeSimul;
					lastShader = "deuteranope";
					Debug.Log("protanope simul set");
                }
                if (onTritanope)
                {
                    currentShader = tritanopeSimul;
					lastShader = "tritanope";
					Debug.Log("protanope simul set");
                }
                background.GetComponent<RawImage>().material.shader = currentShader;
            }
			if (onToggle)
            {
                if (!isShaderOn)
                {
                    background.GetComponent<RawImage>().material.shader = currentShader;
                    isShaderOn = true;
                    Debug.Log("shader on");
                    onToggle = false;

                }
                else
                {
                    background.GetComponent<RawImage>().material.shader = originalShader;
                    isShaderOn = false;
                    Debug.Log("shader off");
                    onToggle = false;
                }

            }
			updateInfoText();
			leaveToggle();
        }
    }
	
	private void updateInfoText() {
		if (isShaderOn) {
			if (onProtanope) infoText.text = "Protanope ";
			if (onDeuteranope) infoText.text = "Deuteranope ";
			if (onTritanope) infoText.text = "Tritanope ";
			if (isDaltonized) infoText.text += "daltonization";
			if (isSimulated) infoText.text += "simulation";
		} else {
			infoText.text = "Filter is off";
		}
	}

    public void toggleShader()
    {
        Debug.Log("on toggle");
        onToggle = true;
    }
	
	public void onSwitchEnter() {
		Debug.Log("on switch");
		onSwitch = true;
	}

    public void leaveToggle()
    {
        Debug.Log("off toggle");
        onToggle = false;
        onProtanope = false;
        onDeuteranope = false;
        onTritanope = false;
		onSwitch = false;
        count = 0;
    }

    public void setProtanope()
    {
        Debug.Log("on protanope");
        onProtanope = true;
    }

    public void setDeuteranope()
    {
        Debug.Log("on deuteranope");
        onDeuteranope = true;
    }

    public void setTritanope()
    {
        Debug.Log("on tritanope");
        onTritanope = true;
    }
}
