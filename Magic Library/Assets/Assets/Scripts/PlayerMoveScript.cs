using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMoveScript : MonoBehaviour
{
    [SerializeField]
    private string horizontalInputName;
    [SerializeField]
    private string verticalInputName;
    [SerializeField]
    private float movementSpeed;

    private CharacterController charController;

    [SerializeField]
    private AnimationCurve jumpFallOff;
    [SerializeField]
    private float jumpMultiplier;
    [SerializeField]
    private KeyCode jumpKey;
    [SerializeField]
    private KeyCode sprintKey;

    [Header("Sounds")]
    private AudioSource audioSource;

    [SerializeField]
    private AudioClip audioJump;


    private bool isJumping;
    private int moveMultiplier = 1;


    private void Awake()
    {
        charController = GetComponent<CharacterController>();
        audioSource = GetComponent<AudioSource>();
    }

    private void Update()
    {
        PlayerMovement();
        if (Input.GetKey(sprintKey))
        {
            moveMultiplier = 2;
        }
        else
        {
            moveMultiplier = 1;
        }

    }
    
    private void PlayerMovement()
    {
    float horizInput = Input.GetAxis(horizontalInputName) * movementSpeed * moveMultiplier;
    float vertInput = Input.GetAxis(verticalInputName) * movementSpeed * moveMultiplier;

    Vector3 forwardMovement = transform.forward * vertInput;
    Vector3 rightMovement = transform.right * horizInput;

    charController.SimpleMove(forwardMovement + rightMovement);

    JumpInput();
    }

    private void JumpInput()
    {
        if(Input.GetKey(jumpKey) && !isJumping)
        {
            isJumping = true;
            StartCoroutine(JumpEvent());
            audioSource.PlayOneShot(audioJump);
        }
    }

    private IEnumerator JumpEvent()
    {
        charController.slopeLimit = 90;
        float timeInAir = 0.0f;

        do
        {
            float jumpForce = jumpFallOff.Evaluate(timeInAir);
            charController.Move(Vector3.up * jumpForce * jumpMultiplier * Time.deltaTime);
            timeInAir += Time.deltaTime;
            yield return null;
        }
        while (!charController.isGrounded && charController.collisionFlags != CollisionFlags.Above);
        {
            charController.slopeLimit = 45;
            isJumping = false;
        }
    }
}
