using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using Valve.VR.InteractionSystem;
using Valve.VR.Extras;

public class PlayerController : MonoBehaviour
{
    public SteamVR_Action_Vector2 input;
    // public SteamVR_Action_Boolean menuinput;
    // public GameObject inGameMenu;
    private AudioSource audioSource;
    public AudioClip walk;
    //private SteamVR_LaserPointer steamVR_LaserPointer_Script;
    public float speed = 2;
    // Start is called before the first frame update
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        //steamVR_LaserPointer_Script = GameObject.Find("RightHand").GetComponent<SteamVR_LaserPointer>();
        //steamVR_LaserPointer_Script.thickness = 0.0f;
    }

    // Update is called once per frame
    void FixedUpdate()
    {

        if (input.axis.magnitude > 0.1f)
        {
            if (!audioSource.isPlaying)
            {
                audioSource.Play();
            }
            Vector3 direction = Player.instance.hmdTransform.TransformDirection(new Vector3(input.axis.x, 0, input.axis.y));
            transform.position += speed * Time.deltaTime * Vector3.ProjectOnPlane(direction, Vector3.up);
        }
        else
        {
            audioSource.Stop();
        }

        /*if (menuinput.stateDown)
        {
            inGameMenu.SetActive(true);
            //steamVR_LaserPointer_Script.thickness = 0.002f;
        }
        else if (menuinput.stateUp)
        {
            inGameMenu.SetActive(false);
            //steamVR_LaserPointer_Script.thickness = 0.0f;
        }*/
        /*if (!menuinput.state)
        {
            inGameMenu.SetActive(true);
        }
        else
        {
            inGameMenu.SetActive(false);
        }*/
    }


}