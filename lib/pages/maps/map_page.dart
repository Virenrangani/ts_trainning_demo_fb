import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {
  late MapController controller;
  @override
  void initState(){
    super.initState();
    controller = MapController.customLayer(
        initMapWithUserPosition:
        UserTrackingOption(enableTracking: true, unFollowUser: false),
        customTile: CustomTile(
          urlsServers: [
            TileURLs(url: "https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png", ),
            TileURLs( url: "https://b.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png", ),
            TileURLs( url: "https://c.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png", ),
          ],
          tileExtension: ".png",
          sourceName: "cartoLight",
        )
    );
  }
  @override
  Widget build(BuildContext context) {

    return BlocProvider<MapCubit>(
      create: (_) => MapCubit(controller),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text("Map"),
                actions: [
                  IconButton(onPressed: (){
                    context.read<MapCubit>().clearAll();
          }, icon: Icon(Icons.delete))
              ],
            ),
            body: BlocBuilder<MapCubit, MapState>(
              builder: (context, state) {
                return OSMFlutter(
                  controller: controller,
                  onMapIsReady: (isReady) async {
                    if (isReady) {

                      controller.listenerMapSingleTapping
                          .addListener(() {

                        final point =
                            controller.listenerMapSingleTapping.value;

                          context.read<MapCubit>().addPoint(point!);

                      });
                    }
                  },
                  osmOption: const OSMOption(
                    zoomOption: ZoomOption(
                      initZoom: 6,
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    print("start tracking");
                      context.read<MapCubit>().startTracking();
                  },
                  child: const Icon(Icons.play_arrow),

                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () =>
                      context.read<MapCubit>().connectRoads(),
                  child: const Icon(Icons.alt_route),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    context.read<MapCubit>().zoomIn();
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    context.read<MapCubit>().zoomOut();
                  },
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}