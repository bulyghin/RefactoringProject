import SVProgressHUD
import RxCocoa
import RxSwift

extension Reactive where Base: SVProgressHUD {

   public static var isAnimating: Binder<Bool> {
      return Binder(UIApplication.shared) { progressHUD, isVisible in
         if isVisible {
             SVProgressHUD.show()
         } else {
            SVProgressHUD.dismiss()
         }
      }
   }

}
