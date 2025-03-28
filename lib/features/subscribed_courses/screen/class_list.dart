import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:takshasila_app/constants/app_constants.dart';
import 'package:takshasila_app/features/subscribed_courses/screen/miscillaneous_folder_screen.dart';
import 'package:takshasila_app/features/subscribed_courses/screen/subject_list.dart';
import 'package:takshasila_app/features/subscribed_courses/services/user_subscriptions_services.dart';
import 'package:takshasila_app/models/classs_list_model.dart';



class ClassList extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String batchId;
  final String courseImage;

  const ClassList({
    required this.courseId,
    required this.courseName,
    required this.batchId,
    required this.courseImage,
    super.key,
  });

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  late Future<ClassListModel?> _classList;

  @override
  void initState() {
    super.initState();
    _classList = UserSubscriptionsServices()
        .getClassList(context: context, courseId: widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          _SwipeableAddReviewSection(courseId: widget.courseId),
      backgroundColor: AppConstant.backgroundColor,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 16, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isCollapsed =
                          constraints.maxHeight <= kToolbarHeight;

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag:
                                "courseImage-${widget.courseId}", // Unique Hero tag
                            child: Image.network(
                              widget.courseImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 45, bottom: 10),
                              child: Text(
                                widget.courseName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isCollapsed ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ];
            },
            body: FutureBuilder<ClassListModel?>(
              future: _classList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData ||
                    snapshot.data!.classes!.isEmpty) {
                  return const Center(child: Text("No classes found"));
                }
                return Wrap(
                spacing: 8, // Horizontal spacing between cards
                runSpacing: 8, // Vertical spacing between rows
                children: [
                  ...snapshot.data!.classes!.map((list) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 2 - 10, // Half-width for a grid layout
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectList(
                                classId: list.classId!,
                                packageId: list.packageid!,
                                batchId: widget.batchId,
                                className: list.className!,
                                classImage: list.classImage!,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: AppConstant.primaryColor,
                              width: 1,
                            ),
                          ),
                          color: AppConstant.cardBackground,
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Hero(
                                  tag: "classImage-${list.classId!}",
                                  child: CachedNetworkImage(
                                    imageUrl: list.classImage ?? "",
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 120,
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      "assets/images/course1.png",
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list.className ?? "Course Name",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  Container( // Wrap the GestureDetector inside a Container
                    width: MediaQuery.of(context).size.width-15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MiscellaneousFolderScreen(courseId: widget.courseId),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: AppConstant.secondaryColorLight,
                            width: 1,
                          ),
                        ),
                        color: AppConstant.cardBackground,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: const [
                              Icon(Icons.folder, size: 50, color: AppConstant.secondaryColor),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Miscellaneous Contents",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeableAddReviewSection extends StatelessWidget {
  final String courseId;

  const _SwipeableAddReviewSection({Key? key, required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          builder: (context) => _AddReviewSheet(courseId: courseId),
        );
      },
      label: const Text('Add review'),
      icon: const Icon(Icons.rate_review),
      backgroundColor: AppConstant.backgroundColor,
      foregroundColor: AppConstant.primaryColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppConstant.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _AddReviewSheet extends StatefulWidget {
  final String courseId;

  const _AddReviewSheet({Key? key, required this.courseId}) : super(key: key);

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  double _rating = 5.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
      ),
      child: SingleChildScrollView(
        // Make it scrollable
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppConstant.cardBackground,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Your Review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your review here...',
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    addUserReview(courseId: widget.courseId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.primaryColor2,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void addUserReview({required String courseId}) {
    UserSubscriptionsServices()
        .createUserCourseReview(
      userId: userData.userid,
      courseid: courseId,
      review: _reviewController.text,
      rating: _rating.toString(),
    )
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $error')),
      );
    });
  }
}
