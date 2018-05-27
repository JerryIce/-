//
//  SetLocationVC.m
//  TQ
//
//  Created by 杨宗维 on 2018/5/27.
//  Copyright © 2018年 Icecooll. All rights reserved.
//

#import "SetLocationVC.h"

@interface SetLocationVC ()
    
    @property (weak, nonatomic) IBOutlet UITextField *field_input;
    
@end

@implementation SetLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finishSetLocation:(id)sender {
    [self performSegueWithIdentifier:@"backFromSetLocationSegue" sender:nil];
}
    

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (_field_input.text != nil){
        _locationName = _field_input.text;
    }
    
}


@end
