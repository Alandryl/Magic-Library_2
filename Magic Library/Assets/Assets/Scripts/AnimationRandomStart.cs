using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationRandomStart : MonoBehaviour
{
    Animator ac;

    void Start()
    {

        ac = GetComponent<Animator>();

        AnimatorStateInfo state = ac.GetCurrentAnimatorStateInfo(0);//could replace 0 by any other animation layer index
        ac.Play(state.fullPathHash, -1, Random.Range(0f, 1f));
    }


    // Update is called once per frame
    void Update()
    {
        
    }
}
