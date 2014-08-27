//
//  AALAddDetailViewController.m
//  jmespace
//
//  Created by Albert Lardizabal on 8/10/14.
//  Copyright (c) 2014 Albert Lardizabal. All rights reserved.
//

#import "AALAddDetailViewController.h"
#import <Parse/Parse.h>

@interface AALAddDetailViewController ()

@property (nonatomic) UITextView *commentView;
@property (nonatomic) UIImageView *picUploadImageView;

@end

@implementation AALAddDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"applogo"]];
    
//    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
//    self.navigationItem.rightBarButtonItem = cameraButton;
    
    UIButton *hideKeyboardButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [hideKeyboardButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    hideKeyboardButton.opaque = YES;
    [self.view addSubview:hideKeyboardButton];
    
    UIView *bgComment = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 150)];
    bgComment.layer.cornerRadius = 5;
    bgComment.layer.masksToBounds = YES;
    bgComment.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:bgComment];
    
    self.commentView = [[UITextView alloc]initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width - 40, 100)];
    self.commentView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.commentView];

    UIImageView *postCommentImage = [[UIImageView alloc]initWithFrame:CGRectMake(155, 120, (self.view.bounds.size.width - 40)/2, 40)];
    postCommentImage.contentMode = UIViewContentModeScaleAspectFit;
    postCommentImage.image = [UIImage imageNamed:@"post_comment"];
    [self.view addSubview:postCommentImage];
    
    UIButton *postCommentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [postCommentButton addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [postCommentButton setTitle:@"" forState:UIControlStateNormal];
    postCommentButton.frame = CGRectMake(155, 120, (self.view.bounds.size.width - 40)/2, 40);
    [self.view addSubview:postCommentButton];
    
    // Add image view for photo selection
    
    self.picUploadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 300, self.view.bounds.size.width - 20, self.view.bounds.size.height/2)];
    self.picUploadImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.picUploadImageView];
    
    // Add toolbar at the bottom of the screen
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"comment"] style:UIBarButtonItemStylePlain target:self action:@selector(postComment:)];
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
    UIBarButtonItem *photoLibButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_photos"] style:UIBarButtonItemStylePlain target:self action:@selector(addPhotoFromLibrary:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolbar.items = [NSArray arrayWithObjects:commentButton, flexibleSpace, cameraButton, flexibleSpace, photoLibButton, nil];
    [self.view addSubview:toolbar];
    
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];

}

- (IBAction)addPhotoFromLibrary:(id)sender
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Put the image into the imageView
    self.picUploadImageView.image = image;
    
    // Save Image
    
    //UIImage *image = [UIImage imageNamed:@"wework_placeholder.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    PFFile *imageFile = [PFFile fileWithName:@"wework_placeholder.png" data:imageData];
    
    PFObject *spacePhoto = [PFObject objectWithClassName:@"Photo"];
    spacePhoto[@"imageName"] = @"wework_CB_1";
    spacePhoto[@"imageFile"] = imageFile;
    spacePhoto[@"parent"] = [PFObject objectWithoutDataWithClassName:@"Space" objectId:self.parseObjectID];
    [spacePhoto saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.commentView resignFirstResponder];
}

- (IBAction)postCommentButtonPressed:(id)sender
{
    
    PFObject *spaceComment = [PFObject objectWithClassName:@"Comment"];
    
    spaceComment[@"content"] = self.commentView.text;
    spaceComment[@"parent"] = [PFObject objectWithoutDataWithClassName:@"Space" objectId:self.parseObjectID];
    [spaceComment saveInBackground];
    
    NSLog(@"Posted");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
