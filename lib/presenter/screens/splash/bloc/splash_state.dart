class SplashState {

}

class SplashInitial extends SplashState {

}

class SplashOpenLogin extends SplashState {

}

class SplashOpenHome extends SplashState {

}

class SplashError extends SplashState {
  final Object error;
  SplashError(this.error);
}
