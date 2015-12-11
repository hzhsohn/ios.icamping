@implementation UINavigationController (rotation)
//temp hack for iOS6, this allows passing supportedInterfaceOrientations to child viewcontrollers.
-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}
-(NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}
@end