import 'package:downy/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

typedef ResultFuture<T> = Future<Either<Failure,T>>;

typedef ResultVoid<T> = ResultFuture<void>;


typedef DataMap = Map<String,dynamic>;