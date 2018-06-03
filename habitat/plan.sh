pkg_name=auto_image_processer
pkg_origin=lancewf
pkg_version="0.1.0"
pkg_maintainer="Lance Finfrock <lancewf@gmail.com>"
pkg_license=("Apache-2.0")
pkg_deps=()

do_build(){
  return 0
}

do_install() {
  mkdir $pkg_prefix/static
  cp *.sh $pkg_prefix/static/.
  chown hab:hab $pkg_prefix/static/*

  return 0
}

