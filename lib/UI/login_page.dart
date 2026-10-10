import 'package:bootcamp_finder/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey =
      GlobalKey<
        FormState
      >(); //رقم تعريف يربطنا بالـ Form عشان نقدر نتحقق منها لاحقاً.

  // إضافة Controllers للتحكم في قراءة النصوص المكتوبة داخل الحقول
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading =
      false; // هل في عملية تسجيل دخول شغالة حالياً؟ (يتحكم بشكل الزر)

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white54, size: 20),
      filled: true, //يعبي الحقل ب لون
      fillColor: const Color(0xFF1C1B22), //اختار اللون
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14), //كم مدورة تكون حواف الحقل
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ), //الخط نفسه اللي يرسم الإطار، بأي لون وبأي سماكة
      ),
      enabledBorder: OutlineInputBorder(
        //شكل الحقل العادي (لما ما تكتبين فيه)
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        //شكل الحقل وأنتِ تكتبين فيه فعلياً (يتغيّر لبنفسجي أوضح
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.deepPurpleAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        //تغليف المحتوى لمنع تداخل العناصر مع حواف الشاشة (مثل كاميرا الهاتف أو شريط الإشعارات العلوي).
        child: SingleChildScrollView(
          //تسمح بالتمرير (سكرول) لو المحتوى أطول من الشاشة
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: Colors.deepPurple.shade200,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white54),
                    ),
                    GestureDetector(
                      //قابل للضغط
                      onTap: () {
                        //لما احد يضغط على هذا النص، سوي هذا الشي.
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        //take one child Gester
                        "Sign up",
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                // حقل البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration(
                    'Email Address',
                    Icons.email_outlined, 
                  ),
                  validator: (value) {
                    //ترجع ترو اور فولس
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // حقل كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, //يخفي الحروف
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Password', Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                 
                  alignment:
                      Alignment.centerRight,
                  child: Text(
                    'Forgot your password?',

                    style: TextStyle(
                      color: Colors.deepPurple.shade200,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              
                SizedBox(
                  width: double.infinity, 
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null // الزر يتعطل تلقائياً أثناء التحميل (Flutter تخليه رمادي لوحدها)
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true; // بداية التحميل: الزر يتعطل وتطلع الدائرة الدوّارة
                              });

                              try {
                                final error = await AuthService.signIn(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                                if (!context.mounted) {
                                  return; // هل الصفحة لسا موجودة؟
                                }

                                setState(() {
                                  _isLoading = false; // نهاية التحميل: الزر يرجع يشتغل عادي
                                });

                                if (error == null) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/main',
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                }
                              } catch (e) {
                                if (!context.mounted) return;
                                setState(() {
                                  _isLoading = false; // حتى لو صار خطأ غير متوقع، لازم نطفي التحميل
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                           
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      
                      child: Divider(color: Colors.white.withValues(alpha: 0.1)), 
                    ),
                    Padding(
                   
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or sign in with',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                      ), 
                    ),
                  ],
                ),
                const SizedBox(height: 20), //فاصل فاضي بين الخط والفيسبوك/جوجل
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1B22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                         
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.g_mobiledata,
                        color: Colors.white70,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15), 
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1B22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.facebook,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
