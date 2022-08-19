using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AnimationControlByFrame : MonoBehaviour
{
    [SerializeField] Animator m_animator;

    public float AnimaionFrame = 0f;

    public float Speed = 0f;

    [SerializeField] Slider slider;

    // Start is called before the first frame update
    void Start()
    {
        m_animator = m_animator.GetComponent<Animator>();
        slider = slider.GetComponent<Slider>();

    }

    // Update is called once per frame
    void Update()
    {
        
        SetAnimationFrame(slider.value);
    }

    public void SetAnimationFrame(float i_frame)
    {
        var clipInfoList = m_animator.GetCurrentAnimatorClipInfo(0);
        var clip = clipInfoList[0].clip;

        float frame = i_frame;

        /*
        if (frame >= 0)
        {
            if (frame > clip.frameRate)
            {
                frame = clip.frameRate-1f;
            }
        }
        else
        {
            frame = 0f;
            Debug.Log(clip.frameRate);
        }
        */

        float time = frame / 365;

        AnimaionFrame = time;

        var stateInfo = m_animator.GetCurrentAnimatorStateInfo(0);
        var animationHash = stateInfo.shortNameHash;


        m_animator.Play(animationHash, 0, time);
        
        //
    }
}
