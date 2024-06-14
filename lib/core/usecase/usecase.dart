import 'package:downy/core/utils/typedef.dart';

abstract class UseCaseWithParams<Type,Params>{
  const UseCaseWithParams();
  ResultFuture<Type> call(Params params);
}

abstract class UseCaseWithoutParams<Type>{
  const UseCaseWithoutParams();
  ResultFuture<Type> call();
}

abstract class UseCaseWithParamsStream<Type,Params>{
  const UseCaseWithParamsStream();
  Stream<Type> call(Params params);
}